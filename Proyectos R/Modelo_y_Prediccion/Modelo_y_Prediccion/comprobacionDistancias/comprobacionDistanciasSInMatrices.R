################################################################################################################
############################# COMPROBACION DISTANCIAS###########################################################
################################################################################################################
#  En este fichero se comprueba que las distancias calculadas a partir de la matriz de distancias se puede hacer
#  simplemente pasandole una lista de dos elementos: para probar el calculo de distancias del medioide a una 
#  secuencia.
################################################################################################################
################################################################################################################

# Limpiar workspace
rm(list=ls())
setwd("D:/Pedro/Master MBIT/Proyecto Master/PROYECTO CODERE/Desarrollo/Desarrollo_VS/codere/Proyectos R/Modelo_y_Prediccion/Modelo_y_Prediccion")
ficheros <- list.files()

is.installed <- function(paquete) is.element (
  paquete, installed.packages())

if(!is.installed("data.table"))
    install.packages("data.table")
if (!is.installed("proxy"))
    install.packages("proxy")
if (!is.installed("tm"))
    install.packages("tm")
if (!is.installed("slam"))
    install.packages("slam")
if (!is.installed("stringdist"))
    install.packages("stringdist")
if (!is.installed("RODBC"))
    install.packages("RODBC")

require(data.table)
require(proxy)
require(tm) # Funciones de minería de textos
require(slam) # Función «crossprod_simple_triplet_matrix»
require(stringdist) # Función seq_distmatrix
require(RODBC)


# ------------------------------------------------------------------
#
# Nombre de la función: creaMatrizNavegacion
#
# Descripción:
# 
# Crea un data.frame cuyas filas son secuencias de navegación y cuyas columnas
# son los pasos de la secuencia
#
# Variables de entrada:
#
# «matrizEntrada»: variable del tipo «dataTable» que contiene una columna
#                  «Secuencia» en la que están las secuencias de navegación
# Variable de salida: 
#
#
# ------------------------ Funciones
# Función que rellena la matriz de clicks
# Filas: secuencias
# Columnas: tantas como posibles acciones

# el resto de la estructura de datos queda con ceros

# creaMatrizNavegacion <- function(matrizSalida, matrizEntrada, codificacion) {
creaMatrizNavegacion <- function(matrizEntrada, codificacion) {
  
  # Se crea dataframe vacío
  matrizSalida <- data.frame(matrix(ncol = 
                                      max(matrizEntrada[["Longitud"]]), nrow=0))
  
  # Se nombran las columnas
  colnames(matrizSalida) <- c(1:max(matrizEntrada[["Longitud"]]))
  fila <- 0
  columna <- 0
  
  # Iteración para cada elemento de la columna «Secuencia»
  sapply(matrizEntrada[["Secuencia"]], 
         function (lista) {
           fila <<- fila + 1 # empleamos <<- para asignar variable en entorno padre
           
           # Iteración para cada paso de la secuencia en cuestión
           sapply(lista, 
                  function(elemento) {
                    columna <<- columna + 1
                    accion <- which(elemento==codificacion)
                    # empleamos <<- para asignar variable en entorno padre
                    matrizSalida[fila, columna] <<- accion
                  })
           columna <<- 0
         })
  # Este es el modo más rápido de convertir en cero los NA
  for (i in seq_along(matrizSalida)) 
    set(matrizSalida, i=which(is.na(matrizSalida[[i]])), j=i, value=0)
  
  return(matrizSalida)
}
# ------------------------------------------------------------------
#
# Nombre de la función: distJac
#
# Descripción:
#
# Variables de entrada:
#
#
# Variable de salida: 
#
#
# Función de distancia 1: distancia Jaccard modificada.
# La distancia Jaccard es: 

# d(x, y) = [cardinal interseccion(x,y)] / [cardinal union(x,y)]

# Modificaciones:
# 1- Se eliminan los ceros, porque no son significativos: x[which(x!=0)]
# 2- Se eliminan las repeticiones: unique
# 3- Se hace caso omiso del orden: Lo proporcionan sin hacer nada especial
#   las funciones de conjuntos «intersect» y «union».

# La función «unlist» es necesaria para convertir lo que es una lista de R,
# que tiene una estructura compleja, en un simple vector sobre el que funcionan
# correctamente las funciones «intersect» y «union».

distJac <- function (x,y) {
  x <- unique(unlist(x[which(x!=0)]))
  y <- unique(unlist(y[which(y!=0)]))
  interseccion <- length(intersect(x,y))
  unido <- length(union(x,y))
  return(1-interseccion/unido)
}

# ------------------------------------------------------------------
#
# Nombre de la función: distTfIdf
#
# Descripción:
#
# Variables de entrada:
#
#
# Variable de salida: 
#
#

# Función de distancia 2: distancia coseno
# Determinar la matriz métrica «coseno» en el espacio de estados TfIdf
# Variables de entrada:
#
# matriz: estructura de datos que contiene los vectores cuyas distancias se van a determinar
# eventosNimios: eventos de la matriz de distancias que se van a retirar antes del 
#                cálculo por ser comunes a todos los vectores o bien por corresponder
#                a eventos poco significativos, como por ejemplo hacer login o 
#                cometer errores.

# La razón para emplear estas estructuras de datos nuevas es que
# hacen uso de matrices dispersas, y son más eficientes que las
# matrices normales

# Funciones útiles

# Pasos más frecuentes
# findFreqTerms(tdm, 2) # Frecuencia mayor que 2
# [1] "10" "11" "12" "20" "33" "50"

# Asociaciones entre pasos
# findAssocs(tdm, "20", 0.8)

# Retirar pasos infrecuentes
# dtm.comun <- removeSparseTerms(dtm, 0.01)

distTfIdf <- function(matriz, eventosNimios) {
  navegaciones<-apply(matriz,1,toString)
  secuencias <- Corpus(VectorSource(navegaciones))
  secuencias <- tm_map(secuencias, removePunctuation)  # quitamos las comas
  secuencias <- tm_map(secuencias, removeWords, eventosNimios) # quitamos eventos poco significativos
  tdm <- TermDocumentMatrix(secuencias,
                            control=list(wordLengths=c(1,Inf)))
  distCoseno <- crossprod_simple_triplet_matrix(tdm)/
    (sqrt(col_sums(tdm^2) %*% t(col_sums(tdm^2))))
  return(as.dist(distCoseno))
}

# ------------------------------------------------------------------
#
# Nombre de la función: distLev
#
# Descripción:
#
# Variables de entrada:
#
#
# Variable de salida: 
#
#
# Función de distancia 3: distancia Levenshtein o distancia tipográfica


distLev <- function(matriz) {
  # Preparamos las secuencias
  listas <- unlist(apply(matriz, 1, list), recursive=FALSE)
  # La función «seq_distmatrix» ya devuelve un objeto del tipo «dist»
  return(seq_distmatrix(listas, method = c("lv")))
}



#------------------------------------------------------
load("D:/Pedro/Master MBIT/Proyecto Master/PROYECTO CODERE/Exploracion Datos/Data Mining/Cargas de Datos/secuencias22-01-LIMPIAS.RData")

muestra <- secuencias[secuencias$Longitud<=10,]
muestra <- muestra[c(1:5),]
matrizClicks <- creaMatrizNavegacion(muestra, tablaCodificacion$action_node_id)


# -------------------- Comprobacion Jacard
distanciaJac <- dist(matrizClicks, method = distJac)
distanciaJac


# Metodo sin Matriz navegacion

# Entre dos secuencias
# La secuencia 1 con la 2 deberia dar 1
distJac(c(187,252),c(67,174,64,67,164,133,133,133,131))
# La secuencia 1 con la 3, deberia dar 0.8
distJac(c(187,252),c(187,174,183,187,174,75))
# La 1 con la 4, deberia dar 0.8571429
distJac(c(187,252),c(187,183,17,35,232,210,183))

# Calculamos todas con la secuencia: 187,104,71
distJac(c(187,104,71),c(187,252))
distJac(c(187,104,71),c(67,174,64,67,164,133,133,133,131))
distJac(c(187,104,71),c(187,174,183,187,174,75))
distJac(c(187,104,71),c(187,183,17,35,232,210,183))
distJac(c(187,104,71),c(187,174,73))


# -------------------- Comprobacion Coseno
# La idea es que tengan más relevancias los pasos más significativos

evPocoSignif<- c(0,
                 88,     # attemptLogin
                 114,    # DirectAccessEventLive: UNKNOWN
                 130,    # errorMsgTicket
                 188,    # LoginKO
                 189,    # LoginKO
                 190,    # LogOut
                 244)    # SelectMarket: UNKNOWN


distanciaCoseno <- distTfIdf(matrizClicks, evPocoSignif)
distanciaCoseno

navegaciones<-apply(matrizClicks,1,toString)
secuencias <- Corpus(VectorSource(navegaciones))
secuencias <- tm_map(secuencias, removePunctuation)  # quitamos las comas
secuencias <- tm_map(secuencias, removeWords, evPocoSignif) # quitamos eventos poco significativos
tdm <- TermDocumentMatrix(secuencias,
                          control=list(wordLengths=c(1,Inf)))
distCoseno <- crossprod_simple_triplet_matrix(tdm)/
  (sqrt(col_sums(tdm^2) %*% t(col_sums(tdm^2))))
as.dist(distCoseno)


# Metodo sin Matriz navegacion
navegaciones <- list(toString(c(187,252)),toString(c(67,174,64,67,164,133,133,133,131)),toString(c(187,174,183,187,174,75)),toString(c(187,183,17,35,232,210,183)),toString(c(187,174,73)))
secuencias <- Corpus(VectorSource(navegaciones))
secuencias <- tm_map(secuencias, removePunctuation)  # quitamos las comas
secuencias <- tm_map(secuencias, removeWords, evPocoSignif) # quitamos eventos poco significativos
tdm <- TermDocumentMatrix(secuencias,
                          control=list(wordLengths=c(1,Inf)))
distCoseno <- crossprod_simple_triplet_matrix(tdm)/
  (sqrt(col_sums(tdm^2) %*% t(col_sums(tdm^2))))
as.dist(distCoseno)

# Entre la secuencia 2 y 3 me deberia salir 0.1533930:
navegaciones <- list(toString(c(67,174,64,67,164,133,133,133,131)),toString(c(187,174,183,187,174,75)))
secuencias <- Corpus(VectorSource(navegaciones))
secuencias <- tm_map(secuencias, removePunctuation)  # quitamos las comas
secuencias <- tm_map(secuencias, removeWords, evPocoSignif) # quitamos eventos poco significativos
tdm <- TermDocumentMatrix(secuencias,
                          control=list(wordLengths=c(1,Inf)))
distCoseno <- crossprod_simple_triplet_matrix(tdm)/
  (sqrt(col_sums(tdm^2) %*% t(col_sums(tdm^2))))
as.dist(distCoseno)


# -------------------- Comprobacion Leveinstein
distLevenshtein <- distLev(matrizClicks)
distLevenshtein

listas <- unlist(apply(matrizClicks, 1, list), recursive=FALSE)
seq_distmatrix(listas, method = c("lv"))


# Metodo sin Matriz navegacion
listas <- list(c(187,252),c(67,174,64,67,164,133,133,133,131),c(187,174,183,187,174,75),c(187,183,17,35,232,210,183),c(187,174,73))
seq_distmatrix(listas, method = c("lv"))

# Entre la secuencia 1 y 2 me deberia salir 9:
listas <- list(c(187,252),c(67,174,64,67,164,133,133,133,131))
seq_distmatrix(listas, method = c("lv"))



# Calculamos todas con la secuencia: 187,104,71
listas <- list(c(187,104,71),c(187,252))
seq_distmatrix(listas, method = c("lv"))
listas <- list(c(187,104,71),c(67,174,64,67,164,133,133,133,131))
seq_distmatrix(listas, method = c("lv"))
listas <- list(c(187,104,71),c(187,174,183,187,174,75))
seq_distmatrix(listas, method = c("lv"))
listas <- list(c(187,104,71),c(187,183,17,35,232,210,183))
seq_distmatrix(listas, method = c("lv"))
listas <- list(c(187,104,71),c(187,174,73))
seq_distmatrix(listas, method = c("lv"))


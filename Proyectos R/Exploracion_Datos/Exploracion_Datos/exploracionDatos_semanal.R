################################################################################################################
################## EXPLORACION DE LOS DATOS SEMANAL  ###########################################################
################################################################################################################
#  Se han realizado dos exploraciones de dos dias en concreto: 22/01 y 27/12. Dias diferentes de la semana 
#  (fin de semana y entre semana).
#  Se han visto algunas diferencias importantes entre ambas exploraciones, por lo tanto hemos convenido que lo mas logico 
#  para definir una muestra representativa seria hacer una comparacion de toda una semana. Porque tenemos la hipotesis que
#  las semanas se comportan igual entre si (hay una compensacion por calendario), sin embargo los dias de la semana
#  no tienen porque comportarse igual, sobre todo fin de semana o entre semana. 
################################################################################################################
################################################################################################################


# Limpiar workspace
rm(list=ls())
setwd("D:/Pedro/Master MBIT/Proyecto Master/PROYECTO CODERE/Exploracion Datos/Data Mining/Exploracion Datos")
ficheros <- list.files()

is.installed <- function(paquete) is.element (
  paquete, installed.packages())

if(!is.installed("ggplot2"))
  install.packages("ggplot2")
if(!is.installed("gridExtra"))
  install.packages("gridExtra")
if(!is.installed("data.table"))
  install.packages("data.table")
if(!is.installed("plyr"))
  install.packages("plyr")
if(!is.installed("fmsb"))
  install.packages("fmsb")

require(ggplot2)
require(gridExtra)
require(data.table)
require(plyr)
require(fmsb)

###### FUNCIONES:#############

evPocoSignif <- c(0)

columnasDeportes <- c("futbol", "baloncesto", "tenis", "voley", "beisbol", "balonmano",
                      "rugby", "futbolAmericano", "mejoraTuLinea", "galgos", "caballos", 
                      "artesMarciales", "boxeo", "dardos", "esports", "hockey", 
                      "loteria", "politica", "borrado", "deporteAnterior")


# En la variable «contadoresApostados» se acumulan los cómputos
# de los deportes a los que se ha apostado
contadoresApostados <- matrix(vector(mode="numeric",
                                     length = length(columnasDeportes)), 
                              ncol=length(columnasDeportes))
colnames(contadoresApostados) <- columnasDeportes

# En la variable «contadoresVisitados» se acumulan los cómputos
# de los deportes a los que se ha visitado
contadoresVisitados <- matrix(vector(mode="numeric",
                                     length = length(columnasDeportes)), 
                              ncol=length(columnasDeportes))
colnames(contadoresVisitados) <- columnasDeportes

# Lista con nombres
listaDeportes <-
  list(futbol = c(9, 11, 32, 35, 108, 112, 120, 210, 214, 216, 223, 
                  227, 252, 266, 273, 286, 357, 330, 17, 157, 160, 
                  232, 238, 294, 326), 
       baloncesto = c(142, 143, 230, 235, 6, 10, 14, 33, 107, 110, 
                      116, 201, 213, 215, 218, 226, 235, 247, 257, 270, 
                      277, 346, 355), 
       tenis = c(21, 180, 242, 307, 354, 12, 36, 113, 121, 211, 224, 
                 228, 253, 267, 287, 309, 333, 334, 336, 374), 
       voley = c(115, 212, 225, 229, 254, 268, 288, 314, 181, 182, 243), 
       beisbol = c(200, 246, 256, 276, 379, 146, 237, 347, 375), 
       balonmano = c(144, 145, 231, 236, 111, 
                     118, 205, 220, 249, 261, 281, 308, 329), 
       rugby = c(178, 179, 209, 222, 234, 241, 251, 265, 285, 356), 
       futbolAmericano = c(140, 158, 159, 198, 217, 239, 245, 255, 
                           269, 275, 337, 325), 
       mejoraTuLinea = c(34, 272), 
       galgos = c(7, 31, 195, 259, 260, 280), 
       caballos = c(161, 168, 196, 262, 282, 358), 
       artesMarciales = c(141, 199, 322, 372, 376), 
       boxeo = c(147, 202, 340, 332), 
       dardos = c(117, 150, 151, 203, 278), 
       esports = c(155, 204, 219, 248, 258, 279, 335, 338, 361), 
       hockey = c(119, 166, 167, 206, 221, 233, 240, 250, 263, 271, 
                  283, 318, 339, 341), 
       loteria = c(170, 171, 207, 264, 284), 
       politica = c(208, 328, 331, 176, 274, 304, 319), 
       borrado = c(152, 153), 
       deporteAnterior = c(-1))


# ---------------------------------------------
# patronBetCompleted
#
# Corta una secuencia en subsecuencias terminadas en «betCompleted».
#
# NOTA: En una secuencia hay un número indeterminado de «betCompleted»
# 
# Variables de entrada:
#
# «secuencia»: es una secuencias de navegación
# «pauta»: La constante «betCompleted» habitualmente.
#
# Variable de salida:
#
# lista de listas. Cada lista es una subsecuencia acabada en «betCompleted»
# La última que se obtiene, que con frecuencia acaba en otro valor, no se 
# devuelve.
#
# Ejemplo de uso:
#
# patronBetCompleted(secuencias[1,]$Secuencias, betCompleted)
# ---------------------------------------------

patronBetCompleted <- function(secuencia, pauta) {
  
  # Posiciones ocupadas por «pauta» en la «secuencia».
  # Normalmente «pauta» es «betCompleted»
  posBetCompleted <- which(unlist(secuencia) %in% c(pauta))
  
  # Cálculo de las diferencias, que se emplean en la
  # elaboración del patrón
  difPosBetCompleted <- diff(posBetCompleted, lag=1)
  
  # Construimos el patrón de corte de la secuencia.
  # Si queremos cortar con la pauta 90 la secuencia
  # 
  # 23, 25, 21, 10, 90, 32, 132, 43, 67, 87, 90, 112, 32
  # el patrón de corte será:
  # 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3
  #
  # NOTA: El patrón de corte debe tener la misma longitud
  # que la secuencia
  patronBetCompleted <- c(posBetCompleted[1], 
                          difPosBetCompleted,
                          length(secuencia)-
                            posBetCompleted[1]-
                            sum(difPosBetCompleted))
  
  # se corta la secuencia en subsecuencias que concluyen
  # en «pauta», que normalmente vale «betCompleted»
  patron<-split(unlist(secuencia), 
                rep(1:length(patronBetCompleted),
                    patronBetCompleted))
  
  # Devolvemos sólo aquellas subsecuencias que contienen «pauta»,
  # que suele valer «betCompleted». Lo normal es que la secuencia
  # acabe con una subsecuencia que no contiene «pauta» al final
  return(patron[sapply(patron, function(x) pauta %in% x)])
}

# ---------------------------------------------
# acumuladorDeportesApostados
#
# Descripción:
#
# Calcula el número de apuestas NETAS y EFECTIVAS realizadas.
#
# NOTA 1: NETAS significa que se descuentan aquellas apuestas
#         que han sido borradas por el apostante.
#
# NOTA 2: EFECTIVAS significa que sólo se consideran aquellas
#         apuestas que han concluido con un «betCompleted».
#
# «acumulaDeportes» entrega el resultado de sus cálculos en una 
# variable global llamada «contadores». He aquí un ejemplo del 
# resultado de esta función.
#
# futbol baloncesto tenis voley beisbol balonmano rugby 
# 41426      15447  2065   744      60      1012    70             
# futbolAmericano gimnasia galgos caballos
#   306               12    3549     3062
# artesMarciales boxeo dardos deportes hockey loteria politica 
#    28           16    115      198   2201      29       18       
# borrado deporteAnterior
#   0               2
#
# Variables de entrada:
#
# «secuencias»: es una matriz de secuencias de navegación
# «listaDep»: Es una «lista con nombres» de deportes como «listaDeportes».
#
# Variable de salida:
#
# No tiene propiamente, aunque entrega los cálculo según se ha descrito.
#
# Ejemplo de uso:
#
# Acumula toda la matriz
# invisible(acumuladorDeportesApostados(secuencias$Secuencia, listaDeportes)) 
#
# Acumula las primeras 100 secuencias
# invisible(acumuladorDeportesApostados(secuencias$Secuencia[1:100], listaDeportes)) 
#
# Acumula las secuencias 1, 7 y 17
# invisible(acumuladorDeportesApostados(secuencias$Secuencia[c(1,7,17)], listaDeportes)) 
# ---------------------------------------------

acumuladorDeportesApostados <- function(secs, listaDep) {
  
  # Aplanamos la lista de deportes. Es útil para hacer búsquedas
  elementos <- unlist(listaDep)
  
  # Iteramos para cada secuencia
  sapply(secs, function(sec) {
    
    # Sólo se sigue si hay «betCompleted» en la secuencia
    if(!is.na(match(betCompleted, sec))) {
      
      # Limpiamos secuencia de elementos que no estén en la lista 
      # de deportes
      sec <- sec[which(sapply(sec, function(x) x %in% 
                                unlist(list(elementos, betCompleted))))]
      
      # Se corta la secuencia según el patron definido por betCompleted
      # en tantas subsecuencias como «betCompleted» haya.
      subSecs <- patronBetCompleted(sec, betCompleted)
      
      # Iteramos para cada una de las subsecuencias
      sapply(subSecs, function(subsec) {
        
        # Iteramos para cada elemento de la secuencia
        sapply(subsec, function(elem) {
          
          # Si no se trata del elemento «betCompleted»
          if(elem != betCompleted) {
            
            # Buscamos a qué deporte pertenece el elemento «elem»,
            # los deportes están en la lista con nombres «listaDep»
            deporte <- names(
              listaDep[sapply(listaDep, function(x) elem %in% x)])
            
            # Si no se trata de un evento de borrado de apuesta
            if(deporte != "borrado") { 
              
              # Incrementamos el contador correspondiente en la matriz de contadores
              contadoresApostados[1, deporte] <<- 
                contadoresApostados[1, deporte] + 1
              contadoresApostados[1,"deporteAnterior"] <<- 
                match(deporte, columnasDeportes)
              
              # Si se trata de un evento de borrado de apuesta
            } else {  
              
              # Decrementamos el contador del deporte anterior
              deporteAnterior <- 
                columnasDeportes[contadoresApostados[[1,"deporteAnterior"]]]
              contadoresApostados[1, deporteAnterior] <<- 
                contadoresApostados[1, deporteAnterior] - 1
            }
          }
        })
      })
    }
  })
}

acumuladorDeportesVisitados <- function(secs, listaDep) {
  
  # Aplanamos la lista de deportes. Es útil para hacer búsquedas
  elementos <- unlist(listaDep)
  
  # Iteramos para cada secuencia
  sapply(secs, function(sec) {
    
    sec <- unlist(sec)[which(sapply(sec, 
                                    function(x) x %in% elementos))]
    
    # Iteramos para cada elemento de la secuencia
    sapply(sec, function(elem) {
      
      
      # Buscamos a qué deporte pertenece el elemento «elem»,
      # los deportes están en la lista con nombres «listaDep»
      deporte <- names(
        listaDep[sapply(listaDep, function(x) elem %in% x)])
      
      # Si no se trata de un evento de borrado de apuesta
      # Incrementamos el contador en la matriz de contadores
      contadoresVisitados[1, deporte] <<- 
        contadoresVisitados[1, deporte] + 1
    })
  })
}

# ---------------------------------------------
# reinicioContadoresApostados
#
# Pone a cero los contadores de los deportes apostados
#
# Variables de entrada: Ninguna
#
# Variable de salida: Ninguna
#
# Ejemplo de uso:
#
# reinicioContadoresApostados()
# ---------------------------------------------

reinicioContadoresApostados <- function () 
  invisible(
    lapply(1:dim(contadoresApostados)[2], 
           function(i) contadoresApostados[1,i] <<- 0))

reinicioContadoresVisitados <- function () 
  invisible(
    lapply(1:dim(contadoresVisitados)[2], 
           function(i) contadoresVisitados[1,i] <<- 0))

#
#
# % de apuestas
#
# ------------------------------------------------------------------
#
# Nombre de la función: mediasBetCompleted
#
# Descripción:
#
# Devuelve la media de «BetCompleted» que hay en las secuencias que 
# hay en «seqs». Incluye en el promedio las secuencias en las que
# no hay «betCompleted».
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Número de «BetCompleted» totales en las secuencias/ Número de secuencias totales
#
# Ejemplos de llamada:
#
# mediasBetCompleted(secuencias[1,])        # Primera secuencia
# mediasBetCompleted(secuencias[1:7,])      # Secuencias de 1 a 7
# mediasBetCompleted(secuencias[c(1,3,7),]) # Secuencias 1, 3 y 7
# mediasBetCompleted(secuencias)            # Todas las secuencias
# ---------------------------------------------
mediasBetCompleted <- function(seqs) {
  return(round(mean(seqs$BetCompleted) ,2))
}

# Esta función es como la anterior, pero devuelve el resultado
# por grupos de longitud de secuencia.

mediasBetCompletedLongitud <- function(seqs) {
  return(unlist(lapply(levels(factor(seqs[["Grupo"]])), 
                       function(grupo) 
                         round(mean(seqs[BetCompleted != 0 & 
                                           Grupo == grupo]$BetCompleted)
                               ,2))))
}

# ------------------------------------------------------------------
#
# Nombre de la función: mediaSecuenciasBetCompleted
#
# Descripción:
#
# Devuelve el promedio de «betCompleted» de las secuencias que contienen 
# algún «BetCompleted»
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Núm secuencias con algún «BetCompleted» / Núm secuencias totales
#
# Ejemplos de llamada:
#
# mediaSecuenciasBetCompleted(secuencias[1,])        # Primera secuencia
# mediaSecuenciasBetCompleted(secuencias[1:7,])      # Secuencias de 1 a 7
# mediaSecuenciasBetCompleted(secuencias[c(1,3,7),]) # Secuencias 1, 3 y 7
# mediaSecuenciasBetCompleted(secuencias)            # Todas las secuencias
# ---------------------------------------------
mediaSecuenciasBetCompleted <- function(seqs) {
  return(round(mean(seqs[seqs[["BetCompleted"]]!=0][["BetCompleted"]]), 2))
}


# ---------- RATIOS entre addBet y CloseBet con referencia a su betCOmpleted
betCompleted <- 90
closeBet <- c(101)
addBet <- c(80:87)


# Ahora se va a tener en cuenta la cantidad de addBet que corresponden a cada betCompleted
# Y de la misma forma la cantidad de closeBet que corresponden a cada betCompleted.
# Y se calcularan unos ratios.
#
#
# Primero / betCompleted
#

# ---------------------------------------------
# ratioPrimero_BetCompleted
#
# Calcula para cada secuencia la ratio Primero/betCompleted.
# 
# Variables de entrada:
#
# «secuencias»: es una matriz de secuencias de navegación
# «primero»: Es el numerador de la ratio, puede ser «AddBet»
#            o «CloseBet».
#
# Variable de salida:
#
# La ratio calculada cuando es posible calcularla. Si el denominador
# es cero, devuelve NA.
# Es interesante señalar que, dada una secuencia, calcula la ratio
# tantas veces como «betCompleted» haya.
#
# Ejemplo de uso:
#
# secuencias$ratio2 <- ratioPrimero_BetCompleted(secuencias$Secuencia, AddBet)
# secuencias$ratio3 <- ratioPrimero_BetCompleted(secuencias$Secuencia, CloseBet)
# ---------------------------------------------

ratioPrimero_BetCompleted <- function(secuencias, primero) {
  
  # Bucle para cada secuencia
  sapply(secuencias, function(sec) {
    
    # Posiciones de BetCompleted y de AddBet
    posBetCompleted <- which(unlist(sec) %in% c(betCompleted))
    posPrimero <- which(unlist(sec) %in% c(primero))
    
    # Si hay algún betCompleted
    if(length(posBetCompleted) !=0) {
      
      # Bucle para cada subsecuencia que contiene betCompleted
      sapply(posBetCompleted, function(pos) {
        
        # Se corta la lista con las posiciones de «primero» pendientes
        numPrimeroAnteriores <- length(posPrimero[posPrimero < pos])
        posPrimero <<- tail(posPrimero, 
                            length(posPrimero) - numPrimeroAnteriores)
        
        # Se devuelve la ratio primero / betCompleted del tramo
        if(numPrimeroAnteriores != 0)
          return(numPrimeroAnteriores)
      })
    } 
    
    # Si no hay betCompleted se devuelve un NA
    else {
      return(NA)
    }
  })
}

# ---------------------------------------------
# ratioSecuenciasPrimero_BetCompleted
#
# Calcula la ratio Primero/betCompleted para un
# dataframe de secuencias
#
# NOTA: Llama a la función «ratioPrimero_BetCompleted» para
#       que calcule la ratio para cada tramo de secuencia
#       con un «betCompleted».
# 
# Variables de entrada:
#
# «secuencias»: es un dataframe de secuencias de navegación
# «Primero»: Es lo que está en el numerador de la ratio, puede ser
#            «AddBet» o «CloseBet».
#
# Variable de salida:
#
# La ratio calculada para el conjunto de secuencias en las que
# se ha apostado
#
# Ejemplo de uso:
#
# ratioSecuenciasPrimero_BetCompleted(secuencias, addBet)
# ratioSecuenciasPrimero_BetCompleted(secuencias, betCompleted)
# ---------------------------------------------

ratioSecuenciasPrimero_BetCompleted <- function(secs, primero) {
  
  # Se llama a la función que calcula las ratios para cada secuencia
  # NOTA 1: La razón para utilizar el <<- es que el lado izquierdo de la asignación
  #         está en el entorno general, no en el de la función.
  # NOTA 2: Es necesario convertir el resultado de la función «ratioAddBet_BetCompleted»
  #         en una lista porque la función devuelve una matriz cuando se la llama desde
  #         aquí. Cuando se la llama de manera interactiva, devuelve una lista. Desconozco
  #         por qué aparece la matriz.
  if(levels(factor(primero %in% closeBet))) {
    lista <<-as.list(ratioPrimero_BetCompleted(secs[["Secuencia"]], primero))
    media <- round(mean(unlist(lista), na.rm=TRUE), 2) 
    return(media)
  }  
  else {
    lista <<-as.list(ratioPrimero_BetCompleted(secs[["Secuencia"]], primero))
    media <- round(mean(unlist(lista), na.rm=TRUE), 2)
    return(media)
  }
}
##############################

####################################################################################
#################### CARGA Y TRATAMIENTO DATOS #####################################
####################################################################################
load("D:/Pedro/Master MBIT/Proyecto Master/PROYECTO CODERE/Exploracion Datos/Data Mining/Cargas de Datos/secuenciasSemana.RData")

# Convertimos el dia de la semana a factor:
secuencias$diaSemana <- factor(secuencias$diaSemana,levels = c("L","M","X","J","V","S","D"))

# Creamos columna de status
# Status: Si hay o no BetCompleted. Si lo hay, Status vale 1, en el otro caso vale 0.
secuencias$Status <- unlist(lapply(1:length(secuencias$Secuencia),
                                   function(i)
                                     if(secuencias$BetCompleted[i] == 0)
                                       return(0)
                                   else
                                     return(1)))

# Creamos un indicados si se loga o no en esa sesion
secuencias$isLogado <- unlist(lapply(secuencias$Secuencia,
                                     function(x){
                                       189 %in% x
                                     }))
head(secuencias,20)

####################################################################################
################################# LIMPIEZA #########################################
####################################################################################
# Tenemos que limpiarlas acorde a como hemos definido en los anteriores analisis

# Guardamos una copia del original:
secuenciasOriginal <- secuencias

# 1. Secuencias que tienen una longitud de 1:
secuencias<-secuencias[secuencias$Longitud>1,]

# 2. Secuencias cuyo estado inicial no tiene sentido de negocio:
acciones.eliminar <- c(c(80:87),c(90,93:99),c(100:105),130,185,186,190)
secuencias_firstAction<-lapply(secuencias$Secuencia, function(l) l[[1]])
secuencias <- secuencias[which(!secuencias_firstAction %in% acciones.eliminar),]
# Comprobamos que la eliminacion se hace correctamente:
acciones.eliminar %in% lapply(secuencias$Secuencia, function(l) l[[1]])

# 4. Outlayers por longitud:
secuencias<-secuencias[secuencias$Longitud<386,]


# Comprobamos que % de la muestra se ha eliminado
print(paste("Secuencias limpias: queda un ",(dim(secuencias)[1]/dim(secuenciasOriginal)[1]*100),"%")) #90.26 %
rm(secuenciasOriginal)
rm(secuencias_firstAction)

#save.image("D:/Pedro/Master MBIT/Proyecto Master/PROYECTO CODERE/Exploracion Datos/Data Mining/Cargas de Datos/secuenciasSemana-LIMPIAS.RData")

#####################################################################################
########################## EXPLORACION DE LOS DATOS #################################
#####################################################################################

# Tamaño de toda la semana
dim(secuencias)[1] # 150829
# Tamaño por dia
tapply(secuencias$IdSesion, secuencias$diaSemana, function(x) length(unique(x)))
# Num Autenticados por dia
tapply(secuencias$isAuthenticated, secuencias$diaSemana, function(x) sum(x))
# Num Logados por dia
tapply(secuencias$isLogado, secuencias$diaSemana, function(x) sum(x))

# Como vemos no tenemos un tamaño lineal por dias, el numero de secuencias
# aumenta mucho en fin de semana (incluso tambien en Miercoles).
# El aumento de autenticados y logados tambien va a corde con el numero de sesiones.
# Era algo esperado.


# Grafica comparativa, num_apostantes, num_autenticados, num_logados
grafoNumSesiones <- list(
  ggplot() + geom_bar(data = secuencias,
                      aes(x=factor(diaSemana),
                          fill=factor(Status)), position = "fill")
  + theme(axis.title.x=element_blank()) 
  + ylab("proporcion")
  + scale_fill_manual("BetCompleted",
                        labels = c("No apuesta", "Apuesta"), values = c("firebrick", "dodgerblue")),
  ggplot() + geom_bar(data = secuencias,
                      aes(x=factor(diaSemana),
                          fill=factor(Status, levels = c(1,0))))
  + theme(axis.title.x=element_blank()) 
  + ylab("frec absoluta")
  + scale_fill_manual("BetCompleted",
                      labels = c("Apuesta", "No apuesta"), values = c("dodgerblue","firebrick"))
  + geom_line(data= ddply(secuencias, .(diaSemana), summarise, isAuthenticated = sum(isAuthenticated)), aes(x = as.numeric(diaSemana), y = isAuthenticated, colour="Autenticado"), size = 2)
  + geom_line(data= ddply(secuencias, .(diaSemana), summarise, isLogado = sum(isLogado)), aes(x = as.numeric(diaSemana), y = isLogado, colour="Logado"), size = 2)
  + scale_colour_manual("Secuencias", breaks = c("Autenticado", "Logado"), values=c("forestgreen","gold"))
  )

marrangeGrob(grafoNumSesiones, nrow=1, ncol = 2, 
             top = "Navegacion Semanal") 

# CONCLUSION:
# Como primer punto destacariamos que el numero de sesiones que apuestan durante la semana
# es muy parecido, repuntando el fin de semana: Sabado Domingo.
# En cuanto al volumen de sesiones destacan Sabado, Domingo y Miercoles. Siendo el primero el que mas
# sesiones tiene. La realidad es que existe una gran diferencia con el resto de dias. Pero en esta grafica
# tambien se observa como la relacion entre apostantes y no apostantes no varia mucho entre dias.
# Por otro lado tenemos las sesiones autenticadas y logadas que entre si son practicamente identicas (su tendencia).
# Y tambien siguen la tendencia del numero de sesiones, no vemos gran diferencia entre los dias, excepto el Jueves
# que da la sensacion que tiene muchas sesiones comparadas con las autenticadas.

# Por lo tanto la relacion apostante/no apostante es bastante lineal durante la semana.
# Obviamente acorde con el numero de usuarios que acceden.
# De igual forma le pasa a los autenticados y logados. Excepto el Jueves que hay una variacion superior.


# Grafica de ratios y apuesta media
ratios <- data.frame(ratio_addBet=c(6,0) , ratio_CloseBet=c(6,0), media_apostantes=c(6,0) , media_total=c(6,0))

for(dia in unique(secuencias$diaSemana)){
  ratio_addBet<-ratioSecuenciasPrimero_BetCompleted(secuencias[secuencias$diaSemana==dia,], addBet)
  media_apostantes<-mediaSecuenciasBetCompleted(as.data.table(secuencias[secuencias$diaSemana==dia,]))
  ratio_CloseBet<-ratioSecuenciasPrimero_BetCompleted(secuencias[secuencias$diaSemana==dia,], closeBet)
  media_total_usuarios<-mediasBetCompleted(as.data.table(secuencias[secuencias$diaSemana==dia,]))
  ratios<-rbind(ratios,c(ratio_addBet,media_apostantes,ratio_CloseBet,media_total_usuarios))
}
rownames(ratios)=c(1,2,"Lunes","Martes","Miercoles","Jueves","Viernes","Sabado","Domingo")

colors_border=rainbow(7)
radarchart(ratios, axistype=1,
           pcol=colors_border, plty=1,
           cglcol="darkgrey", cglty=1, axislabcol="darkgrey", seg=5 ,caxislabels=seq(0,6,1), cglwd=0.8,
           vlcex=0.8,
           vlabels=c("Ratio\naddBet/BetCompleted ", "Media Num.Apuestas\n(entre apostantes)", 
                     "Ratio\ncloseBet/BetCompleted", "Media Num.Apuestas\n(todos usuarios)"),
           title="Caracteristicas Semanales")
legend(x=0.9, y=1.41, legend = rownames(ratios[-c(1,2),]), bty = "n", pch=20, col=colors_border, text.col = "grey", cex=1.2, pt.cex=3)

# CONCLUSION:
# Con esta grafica queriamos verificar cual es el comportamiento con referencia a las principales
# caracteristicas de comportamiento de un usuario a lo largo de la semana. Y la realidad es que no vemos 
# muchas diferencias. 
#   1. Una media de num apuestas de practicamente 2 (entre los apostantes) y cercana a 1 (entre todos los usuarios).
#   2. Un ratio entre cierre de apuesta y apuesta completada muy cercana a 1.
# Tal vez lo que mas varie sea el numero de tickets añadidos por apuesta completadas, que esta entre 4 y 5.
# Siendo muy cercano a 4 el Sabado y muy cercana a 5 el Miercoles.


# Grafica de boxplot semanales, para autenticados y no autenticados.
grafoBoxplot <- list(
  ggplot(data = secuencias, aes(x=diaSemana, y=Longitud, fill=as.factor(isAuthenticated))) 
  + geom_boxplot() 
  + scale_fill_discrete("Autenticado",labels = c("NO", "SI"))
  + theme(axis.title.x=element_blank())
)

marrangeGrob(grafoBoxplot, nrow=1, ncol = 1, 
             top = "Boxplot Semanal") 

# CONCLUSION:
# En cuanto a longitud o tiempo de navegacion, el usuario tanto si esta autenticado como si no
# es practicamente identico por dia.


# Grafica por deporte
deportes.mas.apostados<-c("futbol","baloncesto","tenis","balonmano","hockey","galgos","caballos")
deportes.menos.apostados<-c("voley","esports","futbolAmericano","beisbol", "rugby", "dardos","politica","artesMarciales","mejoraTuLinea", "boxeo", "loteria")
factor.diaSemana <- factor(c("L","M","X","J","V","S","D"),levels = c("L","M","X","J","V","S","D"))

melted.deportes.mas.apostados.semana <- data.frame(stringsAsFactors = T)
melted.deportes.menos.apostados.semana <- data.frame(stringsAsFactors = T)
for(dia in factor.diaSemana){
  reinicioContadoresApostados()
  invisible(acumuladorDeportesApostados(secuencias[secuencias$diaSemana==dia,]$Secuencia, listaDeportes))
  deportes <- sort(as.data.frame(contadoresApostados),decreasing = TRUE)
  melted.deportes.mas.apostados <- data.frame(diaSemana=rep(dia,times=7))
  melted.deportes.mas.apostados<-cbind(melted.deportes.mas.apostados,melt(deportes[,deportes.mas.apostados]))
  melted.deportes.mas.apostados.semana <- rbind(melted.deportes.mas.apostados.semana,melted.deportes.mas.apostados)
  
  melted.deportes.menos.apostados <- data.frame(diaSemana=rep(dia,times=11))
  melted.deportes.menos.apostados<-cbind(melted.deportes.menos.apostados,melt(deportes[,deportes.menos.apostados]))
  melted.deportes.menos.apostados.semana <- rbind(melted.deportes.menos.apostados.semana,melted.deportes.menos.apostados)
}

grafoDeportes <- list(
  ggplot(melted.deportes.mas.apostados.semana, aes(x=as.numeric(diaSemana), y=value, fill=variable)) +
    geom_area(position = "identity")
  + theme(axis.title.x=element_blank()) 
  + ylab("Num.Apuestas")
  + scale_x_discrete(breaks=c("1","2","3","4","5","6","7"),
                    labels=c("L", "M", "X", "J", "V", "S", "D"))
  + scale_y_discrete(breaks=c(0,50000,100000,max(melted.deportes.mas.apostados.semana$value)),
                     labels=c("0", "50.000", "100.000", "140.000"))
  + scale_fill_brewer("Dep.mas apostados", palette = "Set1")
  ,
  ggplot(melted.deportes.menos.apostados.semana, aes(x=as.numeric(diaSemana), y=value, fill=variable)) +
    geom_area(position = "identity")
  + theme(axis.title.x=element_blank()) 
  + ylab("Num.Apuestas")
  + scale_x_discrete(breaks=c("1","2","3","4","5","6","7"),
                     labels=c("L", "M", "X", "J", "V", "S", "D"))
  + scale_fill_brewer("Dep.menos apostados", palette = "Set3")
)

marrangeGrob(grafoDeportes, nrow=1, ncol = 2, 
             top = "Evolucion Semanal Apuestas por Deporte") 

# CONCLUSION:
# En esta grafica queriamos ver como evolucionaban las apuestas a lo largo de la semana
# diferenciandolas entre deportes mas apostados y menos apostados. Obviamente por su magnitud de apuestas,
# que son muy diferentes.
# Aunque todas ellas se comportaran de forma estandar al resto de semanas,
# tenemos variaciones muy interesantes, que se explican unicamente en base a los eventos:
#   1. futbol: Miercoles (Champions Leage), Sabado Domingo (Liga Española)
#   2. baloncesto: Entre semana Copa del Rey Española
#   3. tennis: Entre semana, y domingo: OPEN USA.
#   4. futbol americano: Domingo, final NFL
#   5. Da la sensacion que en videojuegos la gente apuesta mas entre semana, a lo mejor algun evento
#   6. voleyball: Hay un repunte el Lunes y el Viernes, tal vez debido a algun directo.
# El resto de deportes son relativamente lineales, galgos, hockey, caballos, beisbol, rugby, etc..

# El numero de apuestas por deporte, aunque siguen tendencias semanaales se rigen mucho por los eventos.



# Grafico comparativa Deportes Apostados, Deportes visitados
melted.deportes.mas.vistos.semana <- data.frame(stringsAsFactors = T)
melted.deportes.menos.vistos.semana <- data.frame(stringsAsFactors = T)
for(dia in factor.diaSemana){
  reinicioContadoresVisitados()
  invisible(acumuladorDeportesVisitados(secuencias[secuencias$diaSemana==dia,]$Secuencia, listaDeportes))
  deportes <- sort(as.data.frame(contadoresVisitados),decreasing = TRUE)
  melted.deportes.mas.vistos <- data.frame(diaSemana=rep(dia,times=7))
  melted.deportes.mas.vistos<-cbind(melted.deportes.mas.vistos,melt(deportes[,deportes.mas.apostados]))
  melted.deportes.mas.vistos.semana <- rbind(melted.deportes.mas.vistos.semana,melted.deportes.mas.vistos)
}

melted.deportes.mas.apostados.semana$grupo<- "Apuestas"
melted.deportes.mas.vistos.semana$grupo<- "Visitas"
melted.deportes.general <- rbind(melted.deportes.mas.apostados.semana,melted.deportes.mas.vistos.semana)


calculo_ratio_visitas <- function(diaSemana, variable, value, grupo) {
  if(grupo=="Apuestas")
    return(paste(round(value/melted.deportes.mas.vistos.semana[melted.deportes.mas.vistos.semana$diaSemana==diaSemana & melted.deportes.mas.vistos.semana$variable==variable,]$value*100),"%",sep = ""))
  else
    return("")
}

melted.deportes.general<-ddply(melted.deportes.general, .(diaSemana,variable,grupo), summarise, 
      ratio = calculo_ratio_visitas(diaSemana, variable, value, grupo), value=value)


grafoDeportesVisitados <- list(
  ggplot(melted.deportes.general, aes(y = value, x = factor(variable), fill=factor(grupo))) 
  + geom_bar(stat = "identity") 
  + facet_wrap(~diaSemana, scales="free_y") 
  + xlab("Grupo")
  + ylab("Num Apuestas")
  + scale_fill_discrete("Deporte")
  + geom_text(aes(label=ratio), vjust=0,size=3)
  )

marrangeGrob(grafoDeportesVisitados, nrow=1, ncol = 1, 
             top = "Deportes Visitados")

# CONCLUSION:
# Con este grafico queriamos ver si varia mucho la relacion entre apuestas y visitas a un deporte,
# para cada dia de la semana. Solamente lo hemos comprobado con los deportes mas apostados
# , pero lo cierto es que para los menos pasara algo por el estilo.
# Y en general vemos que si que hay variaciones, aunque no muy altas, pero la tendencia es
# que la relacion visitas/apuestas sea mayor en fin de semana.
# En el caso de los galgos y caballos no hay diferencia. Parecen apostadores mas profesionales,
# no tanto por arreon del momento
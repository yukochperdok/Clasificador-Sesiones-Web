# ---------------------------- Funciones de distancia


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

# ------------------------------------------------------------------
#
# Nombre de la función: cogeCluster
#
# Función que devuelve las secuencias correspondientes al grupo «num» 
# de «cluster» y el número de dichas secuencias.
# Sólo puede llamarse cuando los grupos están ya creados con la 
# función «pam».
#
# Variables de entrada:
#
# «matriz» es la matriz que contiene, por filas, secuencias de navegación.
#
# «cluster» puede tomar varios valores. Normalmente hemos trabajado con:
# "Jac5", "Jac8", "Jac11", "TfIdf5", "TfIdf8", "TfIdf11", "Levenshtein5"
# "Levenshtein8", "Levenshtein11"
#
# La parte literal indica la distancia con la que se ha efectuado el 
# agrupamiento.
# La parte numérica indica el número de grupos de dicho agrupamiento.
# Nada impide que se creen otros agrupamientos con la función «pam».
#
# «num» puede valer cualquier número que hayamos escogido a la hora de
# formar los grupos con la función «pam». Normalmente se ha trabajado
# con 5, 8 y 11 grupos
#
# Variable de salida: 
#
# Una lista cuyo primer elemento es el número de secuencias del grupo 
# en cuestión y cuyo segundo elemento es un dataframe constituido por 
# las propias secuencias dispuestas por filas.
#
# Ejemplos de llamada:
# Secuencias del segundo cluster del espacio TfIdf de 11 clusters
# cogeCluster(matrizClicks1BetCompleted_0_20, "TfIdf11",2)
#
# Secuencias del cuarto cluster del espacio Levenshtein de 5 clusters
# cogeCluster(matrizClicks1BetCompleted_0_20, "Levenshtein5",4)
#
# Secuencias del segundo cluster del espacio Jaccard de 8 clusters
# cogeCluster(matrizClicks1BetCompleted_0_20, "Jac8",2)

cogeCluster <- function(matriz, cluster, num) {
  
  # Se crea una sentencia que se va a ejecutar en R.
  # Dicha sentencia va a coger los números de orden de aquellas secuencias
  # que pertenezcan al grupo «num» dentro del agrupamiento «cluster»
  cadena <- paste0("listaGrupos$clustersCodere", cluster, 
                   "$clustering[listaGrupos$clustersCodere", cluster, "$clustering==")
  expresion = parse(text=paste0(cadena,
                                num, "]"))

  # Se llama a la función «eval», es decir, se ejecuta la sentencia R
  # que devuelve las secuencias pertenecientes al grupo «num».
  # Y se llama a la función «names», con lo cual obtenemos el número de orden
  # de la secuencia perteneciente al grupo «num».
  
  nombres <- names(eval(expresion))
  return(list(
    length(nombres),                                  # Número de secuencias
    matriz[unlist(lapply(nombres, as.integer)),]))
}  


# ------------------------------------------------------------------
#
# Nombre de la función: medioidesCluster
#
# Descripción: 
# 
# Dada una agrupación que se pasa como parámetro, devuelve los medioides.
#
# Condición para la llamada :
#
# Sólo puede llamarse cuando el agrupamiento ya está hecho.
#
# Variables de entrada: 
#
# «cluster»: Un agrupamiento. Ejemplos: 
# "Jac5", "Jac8", "Jac11", "TfIdf5", "TfIdf8", "TfIdf11", "Levenshtein5"
# "Levenshtein8", "Levenshtein11"
#
# Variable de salida: 
#
# Las secuencias de navegación correspondientes a los medioides
#

medioidesClusters <- function(cluster) {
  cadena <- paste0("clustersCodere", cluster, "$medoids")
  expresion <- eval(parse(text= cadena))
  return(matrizClicks1BetCompleted_0_20[unlist(lapply(expresion, as.integer)),])
}

# Ejemplos de llamada:

# Medioides del espacio Jaccard con 11 clusters
#medioidesClusters("Jac11")

# Medioides del espacio TfIdf con 8 clusters
#medioidesClusters("TfIdf8")

# Medioides del espacio Levenshtein con 5 clusters
#medioidesClusters("Levenshtein5")

# ---------------------- tf-idf: Transformación propia de la minería de textos
#                     
# La idea es que tengan más relevancias los pasos más significativos




# Función que representa un histograma de «matriz» con los eventos
# más frecuentes. Para ello se eligen aquellos eventos
# con una frecuencia mínima de «frecMin»
# Hace uso de las funciones de minería de textos, que son muy
# potentes para esto
# NOTA: Es complicado conseguir que el histograma salga en orden
# de frecuencias

dibujaCluster <- function(matriz, frecMin, numCluster, 
                          tipo, tamano, verbose, tablaCodif) {
  navegaciones<-apply(matriz, 1, toString)
  secuencia <- Corpus(VectorSource(navegaciones))
  
  # quitamos las comas
  secuencia <- tm_map(secuencia, removePunctuation) 
  
  # quitamos eventos poco significativos
  secuencia <- tm_map(secuencia, removeWords, evPocoSignif) 
  tdm <- TermDocumentMatrix(secuencia,
                            control=list(wordLengths=c(1,Inf)))
  
  # Acumulamos las apariciones de los eventos, se genera una lista con nombres
  vectorFrecuencias <- rowSums(as.matrix(tdm))
  frecue <- sort(vectorFrecuencias, decreasing = TRUE)
  df <- data.frame(action_node_id=names(vectorFrecuencias), 
                   freq=unname(vectorFrecuencias))
  
  # Sólo representamos lo que supera el umbral «frecMin»
  df <- subset(df, freq>frecMin)
  
  # Esto que viene ahora es lo que hay que hacer para ordenar el gráfico por abscisas
  # tenemos que cambiar el orden de los factores explícitamente
  # Para eso empleamos la opción «levels», y le decimos que ordene los eventos según la frecuencia
  df$action_node_id <- 
    factor(df$action_node_id, 
           levels = df$action_node_id[order(df$freq, decreasing=TRUE)])
  
  if(verbose) {
    # Fusionamos los dataframes para que aparezca el nombre comprensible de cada paso de navegación
    df <- merge(df, tablaCodificacion, by="action_node_id")
    # Ordenamos descendentemente por frecuencia
    #arrange(df,desc(freq))
    print(df[order(-df$freq),c(1:3)])
  }
  p <- ggplot(df, aes(x=action_node_id, y=freq))    
  p <- p + geom_bar(stat="identity")   
  p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
  p <- p + ggtitle(paste0(tipo, ", grupo ", numCluster, ", ", 
                          tamano, " secuencias"))
  p
}

graficaClusters <- function(matriz, dista, numClusters, 
                            frecMinima, verbose, tabla) {
  filas <- as.integer(numClusters/2)
  multigrafo <- lapply(1:numClusters, function(clus) {
    cluster <- cogeCluster(matriz,
                           paste0(dista,numClusters),
                           clus)
    tamanoCluster <- cluster[[1]]
    secuenciasCluster <- cluster[[2]]
    dibujaCluster(
      secuenciasCluster, 
      frecMinima, 
      clus, 
      dista,
      tamanoCluster,
      verbose,
      tabla)
  })
  filas <- as.integer(numClusters/2)
  #  marrangeGrob(multigrafo, nrow=filas, ncol = numClusters - filas)
  marrangeGrob(multigrafo, 
               nrow=3, 
               ncol = as.integer(numClusters/3 + 1), 
               top = paste0(dista, " con ", numClusters, 
                            " grupos, frec mín: ", frecMinima))
}


# Función para Carlos, está configurado para la distancia de Jaccard

distMedioide <- function(medioide, matrizSecuencias) {
  return(apply(matrizSecuencias, 1, 
               function(x) distJaccard(medioide, x)))
}

# Ejemplos de utilización

# Vector de distancia de todas las navegaciones con respecto al primer medioide
# distMedioide(medioidesClusters("Jac5")[1,], matrizClicks1BetCompleted_0_20)

# Vector de distancia de todas las navegaciones con respecto a la primera navegación
# distMedioide(matrizClicks1BetCompleted_0_20[1,], matrizClicks1BetCompleted_0_20)


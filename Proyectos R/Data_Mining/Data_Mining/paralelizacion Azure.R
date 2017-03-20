
nombreUsuario <- "sshmbitschool"
dirDatos <- paste0("/home/", nombreUsuario, "/datos")
dirFicheros <- paste0("/home/", nombreUsuario, "/datos/semana")
ficheroSalida <- "distanciaSemana.rds"
# ----------------------- Funciones

calculaNodos <- function(seqs, tamano, lista) {
  if(seqs > tamano) {
    factor <- seqs %/% (tamano + 1) + 1
    numNodos <- length(lista) * factor
  } else {
    factor <- 1
    # Número de nodos de cálculo
    numNodos <- length(listaNodos)
  }
  return(list(numNodos, factor))
}

calculaFilas <- function(num, nNodos) {
  numComb <- choose(num, 2)
  tramo <- numComb %/% nNodos
  long <- num - 1
  longFilas <- seq(long, 1, -1)
  posiciones <- c()
  fila <- 0
  
  for(i in 1:nNodos) {
    longFilasAcum <- cumsum(longFilas)
    
    
    if(any(tramo < longFilasAcum)) {
      fila <- min(which(tramo < longFilasAcum))
      posiciones <- c(posiciones, fila)
      coge <- longFilasAcum[fila]
      longFilas <- tail(longFilas, 
                        length(longFilas) - fila)
      numComb <- numComb - coge # %/% 2 
      if(numComb > 0) {
        tramo <- numComb %/% (nNodos - i)
      }
    } else {
      posiciones <- append(posiciones, 
                           num - sum(posiciones) - 1)
    }
  }
  return(append(0, cumsum(posiciones)))
}

calculaDistancia <- function(matriz, vuelta, secuencias) {
  
  # Cada 5 iteraciones se libera la memoria
  # if (vuelta %% 5 == 0)
  #  system("sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'")
  
  # Mandamos la ocupacion de la memoria a un fichero
  # mem <- paste0("free -m > memorialinux", vuelta,".m")
  # system(mem)
  
  if("proxy" %in% loadedNamespaces()) {
    require(proxy, lib.loc = "/tmp")
  } else {
    install.packages("proxy", lib = "/tmp")
    require(proxy, lib.loc = "/tmp")
  }
  if("Rcpp" %in% loadedNamespaces()) {
    require(Rcpp, lib.loc = "/tmp")
  } else {
    install.packages("Rcpp", lib = "/tmp")
    require(Rcpp, lib.loc = "/tmp")
  } 
  if(!file.exists("/tmp/distanciaJacard.cpp")) {
    rxHadoopCopyToLocal("/codeR/distanciaJaccard.cpp", "/tmp")
  }


  sourceCpp("/tmp/distanciaJaccard.cpp") 

  kk <- proc.time()
  lista <- c()
  
  distancias <-
    round(dist(matriz[secuencias[1]:secuencias[2],], 
               matriz[secuencias[3]:secuencias[4],], 
               method = distJaccard), 2)
  #             method = "eJaccard"), 2)
  distancias <- t(distancias)
  distancias[upper.tri(distancias)] <- NA

  #on.exit(rm(distancias))
  #on.exit(rm(matriz))
  # Esta sentencia es esencial porque se perdia memoria al trasponer la matriz
  #on.exit(gc())
  return(list(unlist(distancias), proc.time()-kk, Sys.info()[["nodename"]]))
}

# ----------------------- Fin de funciones


setwd(dirDatos)
matrizClicks <- readRDS("matrizClicks_muestra.rds")

kk <- proc.time()

# ---------------- #1 Preparación de la paralelización

# Número de secuencias. En un día son unas 24.000
numSecuenciasTotales <- 24000
tamanoIteracion <- 1000 

#resto <- numSecuenciasTotales %% tamanoIteracion 

# Nodos del cluster, con los números que asigna Azure, cuidado.
listaNodos <- list(0,1,2,3,4,7,8)
#listaNodos <- list(0,1,2,3)

nodos <- calculaNodos(numSecuenciasTotales, 
                      tamanoIteracion, 
                      listaNodos)
numNodos <- nodos[[1]]
vueltasNodos <- nodos[[2]]
numNodosVerdadero <- length(listaNodos)

# Lista de secuencias que van a ir a los nodos
listaSecuencias <- list()
listaSecuencias <- append(listaSecuencias,rep(-1, numNodos))

# ---------------- Fin de #1

# ---------------- #2 Se crean las estructuras que se envían 
#                     a cada nodo

# Utilizamos para una muestra de tamaño adecuado 
# de matrizClicks
mat <- matrizClicks[1:numSecuenciasTotales,]


filasMatrizDistancia <- calculaFilas(numSecuenciasTotales, numNodos)
for(i in 1:numNodos) {
  x1 <- filasMatrizDistancia[i]+1
  x2 <- filasMatrizDistancia[i+1]
  x3 <- x1 + 1
  listaSecuencias[[i]] <- c(x1, x2, x3, numSecuenciasTotales)
}
#names(listaSecuencias) <- 
#  unlist(lapply(0:(numNodos-1), 
#  unlist(lapply(listaNodos, 
#                function(i) paste0("wn",i,"-mbitsc")))

# ---------------- Fin de #2

# ---------------- #3 Código que se ejecuta en los nodos
# En este punto se envía a cada nodo i la información correspondiente:
# - El código de cálculo de la distancia.
# - Las secuencias contenidas en nodo[i]
# - Las distancias que deben calcularse, que están en parejas[[i]]

# A continuación viene el código de cálculo de las distancias en el nodo i.
# Se observará que NO se calculan todas las distancias posibles, SINO SOLO
# LAS QUE CORRESPONDEN AL NODO EN CUESTIÓN, que ni siquiera son todas las
# que podrían calcularse con las secuencias disponibles. Están almacenadas 
# en parejas[[i]]






# ---------------- Fin de 5#
# ---------------- #6 Preparación del cluster

# Directorio de salida en HDFS
myHdfsShareDir = paste( "/user/RevoShare", Sys.info()[["user"]],
                        sep="/" )

# Definición del contexto de cálculo
# La función RxHadoopMR detecta el número de nodos
contexto <- RxHadoopMR(hdfsShareDir = myHdfsShareDir,
                       port = 8020,
                       wait = FALSE,
                       consoleOutput = FALSE)

# Establecimiento del contexto «contexto»
rxSetComputeContext(contexto)

# ---------------- Fin de #6

# ---------------- #7 Cálculos distribuidos

listaSubMatrices <- rep(list(-1), numNodos)

# datos <- c() 
datosIteracion <- c()

for (vuelta in 1:vueltasNodos) {
  print(paste0("V:", vuelta))
  
  resultado <- list()
  listaSecuenciasNodos <- list()
  gc()
  for(nodo in 1:numNodosVerdadero) {
    indice <- (vuelta - 1) * numNodosVerdadero + nodo
    listaSecuenciasNodos[[nodo]] <- listaSecuencias[[indice]]
  }
  rxgLastPendingJob <- 
    rxExec(calculaDistancia,            # funcion
           mat,                         # parametros comunes
           vuelta,
           rxElemArg(listaSecuenciasNodos))  # parametros del nodo
  
  # Se espera a que acabe el cálculo en los nodos
  rxWaitForJob(rxgLastPendingJob) == "finished"
  
  # En «resultado» se recibe toda la información de los nodos
  resultado[[vuelta]] <- rxGetJobResults(rxgLastPendingJob)
  
  # Aquí tenemos una estructura para recibir las listas de los nodos
  # Se trabaja por columnas porque es más conveniente para la creación
  # de la matriz triangular inferior de distancias.
  # print(resultado[[1]]$rxElem1)
  
  setwd(dirFicheros)
  vector <- rep(list(-1), numNodosVerdadero)
  for(nodo in 1:numNodosVerdadero) {

    # En «elemento» está el cálculo realizado por el nodo i
    elemento <- paste0("resultado[[", vuelta, "]]$rxElem", nodo, "[[1]]")
    pos <- (vuelta - 1) * numNodosVerdadero + nodo
    listaSubMatrices[[pos]] <- eval(parse(text = elemento))
    rango <- dim(listaSubMatrices[[pos]])[2]
    print(paste0("n: ", nodo))
    for(j in 1:rango) {
      # En «datos» están los valores ordenados de la matriz métrica
      # Evitamos los valores que están por encima de la diagonal principal, que
      # son del tipo NA
      vector[[nodo]] <- 
        append(vector[[nodo]], 
               listaSubMatrices[[pos]][,j][!is.na(listaSubMatrices[[pos]][,j])])
    }
    print("vtor")
    

    # Este procedimiento de creacion de «datos» a partir de «vector» es mucho
    # mas rapido que si el append hubiera sido datos <- append(datos, ...)
    # Observese que eliminamos el primer elemento, que es un -1 que se encuentra
    # a causa de cómo hemos creado la estructura de datos pero es un dato inconveniente
    datosIteracion <- append(datosIteracion, vector[[nodo]][2:length(vector[[nodo]])])
    
    # Evitamos hacerlo así y vamos a recoger los datos de los ficheros
    #datos <- append(datos, vector[[nodo]][2:length(vector[[nodo]])])
    print("d")
    vector[[nodo]] <- -1
    listaSubMatrices[[pos]] <- -1
    gc()
    # En «tiempo» está almacenado el tiempo que ha tardado la tarea en el nodo
    tiempo <- paste0("resultado[[", vuelta,"]]$rxElem", nodo, "[[2]]")
    #print(eval(parse(text = tiempo)))
    
    # En «nod» está almacenado el nodo que ha hecho el cálculo
    nod <- paste0("resultado[[", vuelta,"]]$rxElem", nodo, "[[3]]")
    #print(eval(parse(text = nod)))
  }
  saveRDS(datosIteracion, paste0("dista",vuelta,".rds"))
  datosIteracion <- c()
  gc()
}

# ---------------- Fin de #7

# ---------------- #8 Reconstrucción de la matriz métrica en origen


setwd(dirFicheros)
datosNodos <- c() 
numFicheros <- numSecuenciasTotales %/% tamanoIteracion
for(fich in (1:numFicheros)) {
  kk1 <- proc.time()
  nombreFichero <- paste0("dista",fich,".rds")
  print(nombreFichero)
  datosNodos <- append(datosNodos, readRDS(nombreFichero))
  print(proc.time()-kk1) 
}


print("Construccion de la matriz metrica")
# Matriz métrica vacía
dista <- matrix(, nrow = numSecuenciasTotales, ncol = numSecuenciasTotales)
# Se copia la lista en una matriz triangular inferior
dista[lower.tri(dista)] <- datosNodos

# Se convierte en formato «dist».
dista <- as.dist(dista)
print(proc.time()-kk) 

saveRDS(dista, ficheroSalida)

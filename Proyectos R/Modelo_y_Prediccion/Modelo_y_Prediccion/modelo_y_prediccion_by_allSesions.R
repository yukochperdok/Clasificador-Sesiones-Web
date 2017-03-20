

rm(list=ls())
setwd("D:/Pedro/Master MBIT/Proyecto Master/PROYECTO CODERE/Exploracion Datos/Data Mining/Modelo y prediccion")
ficheros <- list.files()

is.installed <- function(paquete) is.element (
  paquete, installed.packages())

if(!is.installed("proxy"))
  install.packages("proxy")
if(!is.installed("tm"))
  install.packages("tm")
if(!is.installed("slam"))
  install.packages("slam")
if(!is.installed("stringdist"))
  install.packages("stringdist")
if(!is.installed("RODBC"))
  install.packages("RODBC")

require(proxy)
require(tm)      # Funciones de minería de textos
require(slam)    # Función «crossprod_simple_triplet_matrix»
require(stringdist) # Función seq_distmatrix
require(RODBC)


# ------------------------------------------------------------------
#
# Nombre de la función: conecta_BD
#
# Descripción:
#
# Función que configura el enlace con la base de datos de Azure
# En este caso, la Base de Datos se llama 
#
# Variables de entrada: Ninguna
#
# Variable de salida: Conector de la base de datos que se empleará
# para lanzar peticiones.
#
#

conecta_BD <- function() {
  driver <- 'SQL Server'
  server <- 'tcp:produccion-server-bd.database.windows.net,1433'
  database <- 'PRODUCCION_BD'
  uid <- 'cronodata@produccion-server-bd'
  pwd <- 'Cr0n0data'
  Encrypt <- 'yes'
  TrustServerCertificate <- 'no'
  Connection_Timeout <- '30'
  
  connectionString <- paste0(
    "Driver=", driver,
    ";Server=", server,
    ";Database=", database,
    ";Uid=", uid,
    ";Pwd=", pwd,
    ";Encrypt=", Encrypt,
    ";TrustServerCertificate=", TrustServerCertificate,
    ";Connection Timeout=", Connection_Timeout)
  
  #Apertura de conexión
  dbconnector <- odbcDriverConnect(connectionString)
  return(dbconnector)
}

close_BD <- function(BD) {
  #The close method returns 0 (success) or 1, invisibly.
  return(odbcClose(BD))
}


cargaModelosClusterizacion <- function(BD) {
  # Cargamos el modelo de clusterizacion cargado en la tabla.
  # Es decir cargamos la descripcion de todos los clusteres entrenados, sus metricas, mediodes y la distancia que los identifica
  modelo <- sqlQuery(BD, 'select name_clusterizacion,distancia,name_cluster,medioide from dbo.clusters')
  
  # Transformo la columna medioide en cadena de caracteres porque no la quiero como factor
  modelo[, "medioide"] <- sapply(modelo[, "medioide"], as.character)
  return (modelo)
}

cargaSecuenciasAClusterizar <- function(BD) {
  # Cargamos las secuencias que queremos clusterizar (todas las sesiones pendientes de clusterizar)
  secuenciasAClusterizar <- sqlQuery(BD, 'select session_id,secuencia from dbo.streaming_sequencies')
  
  # Transformo la columna secuencia en cadena de caracteres porque no la quiero como factor
  secuenciasAClusterizar[, "secuencia"] <- sapply(secuenciasAClusterizar[, "secuencia"], as.character)
  return (secuenciasAClusterizar)
}


insertarSecuenciaSolicitada <- function(BD, df) {
  success <- sqlSave(BD, df, tablename = "solicited_sequencies", append = TRUE, rownames = FALSE, verbose = TRUE)
  return (success)
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


distLev <- function(x,y) {
  # Preparamos las secuencias
  listas <- list(as.vector(x),as.vector(y))
  # La función «seq_distmatrix» ya devuelve un objeto del tipo «dist»
  return(seq_distmatrix(listas, method = c("lv")))
}


distMedioide <- function(medioide, secuencia, distancia) {
  return(ifelse(distancia=="Jac",distJac(medioide,secuencia),
                ifelse(distancia=="Lev",distLev(medioide,secuencia),0)))
}

devuelveCluster <- function (clusterizacion, secuencia){
  # Se recoge la posicion que ocupa el cluster que tiene la menor distancia entre el medioide y la secuencia.
  # Se presupone que todos los cluster de una clusterizacion han sido calculados con una de estas 3 distancias:
  # Jac --> Distancia Jaccard modificada
  # Lev --> Distancia Levehistein
  distancia <- unique(clusterizacion$distancia)
  pos.cluster <- which.min(lapply(clusterizacion$medioide,function(x){distMedioide(unlist(lapply(strsplit(x, ","),as.numeric)),secuencia,distancia)}))
  return(clusterizacion[pos.cluster,])
}


# Conexión a la Base de Datos
BD <- conecta_BD()

# PARAMETRO ENTRADA
# 1. Como entrada tenemos todas las secuencias a clusterizar
secuenciasAClusterizar <- cargaSecuenciasAClusterizar(BD)
secuenciasAClusterizar

# 2. Recojo todas las clusterizaciones e identifico las posibles clusterizaciones
clusterizaciones <- cargaModelosClusterizacion(BD)
nameClusterizaciones <- unique(clusterizaciones$name_clusterizacion)

# Data frame que tendra la secuencia con cada una de los clusteres a los que pertenece
df.adnClientes <- data.frame()

# Para cada secuencia, vamos a hallar su cluster mas proximo de cada clusterizacion
# y la iremos incluyendo en un data frame de adnCliente
for(pos_sec in c(1:dim(secuenciasAClusterizar)[1])){
  # Recogemos la secuencia de acciones y la convertimos a vector
  secuenciaSolicitada <- unlist(lapply(strsplit(secuenciasAClusterizar[pos_sec,]$secuencia, split=","),as.numeric))
  secuenciaSolicitada
  
  # Recogemos la sesión
  session_id <- secuenciasAClusterizar[pos_sec,]$session_id
  session_id
  
  # Data frame que tendra la secuencia con cada una de los clusteres a los que pertenece
  df.adnCliente <- data.frame()
  
  # Para cada clusterizacion calculo con respecto a su distancia (Lev o Jac)
  # cual seria el cluster apropiado para la secuencia de entrada
  for(name in nameClusterizaciones){
    clusterAjustado <- devuelveCluster(clusterizaciones[clusterizaciones$name_clusterizacion==name,],secuenciaSolicitada)
    # Como salida tenemos el cluster al que pertenece la secuencia solicitada de la clusterizacion con nombre 'name'
    
    # La incluimos en el ADN del cliente
    secuencia <- data.frame(session_id=session_id, secuencia=toString(secuenciaSolicitada), name_clusterizacion=clusterAjustado$name_clusterizacion, name_cluster=clusterAjustado$name_cluster)
    df.adnCliente <- rbind(df.adnCliente,secuencia) 
  }
  
  # Incluimos en el ADN de todos los clientes
  df.adnClientes <- rbind(df.adnClientes,df.adnCliente) 
}

######################### Aqui hay dos opciones:##########################
## OPCION 1: Insertamos en una tabla de secuencias solicitadas (a modo de historico):

# Insertamos todos el ADN de todos los clientes en la tabla correspondiente para que pueda ser consultada
# correcto <- TRUE
# if(nrow(df.adnClientes)!=0){
#   insercion.correcta <- insertarSecuenciaSolicitada(BD,df.adnClientes)
#   if(!insercion.correcta){
#     print("Ha habido un error en la insercion en la tabla solicited_sequencies")
#     correcto <- FALSE
#   }
# }else{
#   print("No se ha encontrado ningun cluster")
#   correcto <- FALSE
# }
# 
# # PARAMETRO DE SALIDA:
# df.salida <- data.frame(exito = correcto)
# df.salida
# 
# # Conexión a la Base de Datos
# close_BD(BD)


###########################################################################
## OPCION 2: Devolvemos el ADN de todos los clientes calculado (es decir
# tendriamos solo las secuencias clusterizadas en esta ejecuccion):

# PARAMETRO DE SALIDA:
df.salida <- df.adnClientes
df.salida

# Conexión a la Base de Datos
close_BD(BD)
###########################################################################

################################################################################################################
################################### CARGAS DE DATOS  ###########################################################
################################################################################################################
#  En este fichero realizaremos la conexion a BBDD y nos iremos trayendo todos los datos de un dia en concreto
#  o de varios dias y los transformaremos en listas de secuencias que guardaremos como imagen para ser utilizadas
#  tanto en la exploracion de los datos como en el Data Mining
################################################################################################################
################################################################################################################


rm(list=ls())
setwd("D:/Pedro/Master MBIT/Proyecto Master/PROYECTO CODERE/Exploracion Datos/Data Mining/Cargas de Datos")
ficheros <- list.files()

is.installed <- function(paquete) is.element (
  paquete, installed.packages())

if(!is.installed("RODBC"))
  install.packages("RODBC")
if(!is.installed("data.table"))
  install.packages("data.table")


require(RODBC)
require(data.table)


betCompleted <- 90

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
  server <- 'tcp:database-server-produccion.database.windows.net,1433'
  database <- 'database-produccion'
  uid <- 'cronodata@database-server-produccion'
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


# ------------------------------------------------------------------
#
# Nombre de la función: close_BD
#
# Descripción:
#
# Función que cierra la conexion a BBDD
#
close_BD <- function(BD) {
  #The close method returns 0 (success) or 1, invisibly.
  return(odbcClose(BD))
}

# ------------------------------------------------------------------
#
# Nombre de la función: extraeSesiones
#
# Descripción:
# 
# Función que recibe la información bruta de la Base de Datos y conforma
# una estructura de tipo «data.table» con las siguientes columnas:
#
# «IdSesion»: Identificador de la sesión.
# «Secuencia»: Secuencia de navegación codificada y separada por comas.
# «BetCompleted»: Número de eventos tipo «betCompleted» que contiene la secuencia.
# «Longitud»: Longitud de la secuencia
#
# Variables de entrada:
#
# «datosCodere»: Variable del tipo «data.frame» con datos en bruto de la
#                base de datos. En cada fila contiene un paso de navegación.
# «sesiones»: Lista con los identificadores de todas las sesiones.
#
# Variable de salida: 
#
# Una estructura de datos del tipo «data.table»
#

extraeSesiones <- function(datosCodere, sesiones) {
  # Creamos dataframe vacío que en principio tiene sólo la columna de IdSesion
  datosCodereSesiones <- data.frame(IdSesion= character(),stringsAsFactors = F)
  
  # Creamos dataframe de trabajo para el bucle
  df <- datosCodereSesiones[0]
  
  # Para cada sesión
  for(ses in sesiones) {
    # Añade una fila al dataframe df correspondiente a la sesión
    df <- rbind(df,
                data.frame(IdSesion=ses,
                           stringsAsFactors = F))
    # Recorremos el dataframe Datoscodere y recogemos todos los eventos
    # correspondientes a una sesión, en forma de lista
    secuencia <- c()
    for(subses in datosCodere[datosCodere$context_session_id==ses,]$action_node_id) {
      secuencia <- c(secuencia,subses)
    }
    
    print(ses)
    secuencia_authenticated <- c()
    #print("paso 1")
    for(subses in datosCodere[datosCodere$context_session_id==ses,]$context_user_is_authenticated) {
      #print("paso 2")
      #print(subses)
      secuencia_authenticated <- c(secuencia_authenticated,subses)
      #print(secuencia_authenticated)
    }
    
    # Creamos celda que contiene secuencia de toda la navegacion de una sesion y la secuencia de 
    # Authenticateds.
    # La primera vez que se hace, además, se crea una nueva columna en el dataframe df
    df$Secuencia<-list(secuencia)
    df$Secuencia_authenticated<-list(secuencia_authenticated)
    datosCodereSesiones<-rbind(datosCodereSesiones,df)
    
    df <- datosCodereSesiones[0]
  }
  #print("columnas secuencias creadas")
  
  # El nombre de cada fila es el de la sesión
  rownames(datosCodereSesiones) <- sesiones
  
  # Creamos columna BetCompleted en la que se indica si la navegación contiene o no un BetCompleted
  #
  # Empleamos «unlist» porque es necesaria una lista normal para copiarla
  # en un dataframe, no una lista de listas, que es lo que produce «lapply»
  datosCodereSesiones$BetCompleted <- 
    unlist(lapply(datosCodereSesiones$Secuencia, 
                  function(x) length(which(x == betCompleted))))
  
  
  # Creamos columna authenticated en la que se indica si la navegación contiene o no un authenticated
  #
  # Empleamos «unlist» porque es necesaria una lista normal para copiarla
  # en un dataframe, no una lista de listas, que es lo que produce «lapply»
  datosCodereSesiones$authenticated <- 
    unlist(lapply(datosCodereSesiones$Secuencia_authenticated, 
                  function(x) length(which(x == "True"))))
  
  #print(datosCodereSesiones$authenticated)
  
  # El motivo del paso a data.table es que el rendimiento es mucho 
  # mayor que el del dataframe
  # Se comenta el código de datatable porque la versión de R de ML Studio no lo soporta
  datosCodereSesiones <- as.data.table(datosCodereSesiones)
  
  # Añadimos un campo con la longitud
  datosCodereSesiones$Longitud<-sapply(datosCodereSesiones$Secuencia, length)
  
  return(datosCodereSesiones)
}
# ------------------------------------------------------------------
#
# Nombre de la función: cargaSecuencias
#
# Descripción:
# 
# Función que recibe una consulta y la lanza sobre la BBDD, a partir de los datos recibidos
# conforma la secuencia de pasos para cada sesion y devuelve dicho objeto de secuencias.
#
# Variables de entrada:
#
# «consulta»: consulta a realizar sobre la BBDD
#
# Variable de salida: 
#
# Una estructura de datos del tipo «data.table» que contiene la secuencia de cada sesion
#
cargaSecuencias <- function(consulta) {
  
  # Lectura de registros
  datosCodere <- sqlQuery(BD, consulta)
  
  # Veamos los usuarios registrados
  dim(datosCodere)[1]
  
  # Separamos la información temporal en día y hora, que se almacenan
  # en sendas columnas y eliminamos columna de partida
  datosCodere$fecha <- substring(datosCodere$context_data_event_time, 1, 10)
  datosCodere$hora <- substring(datosCodere$context_data_event_time, 12, 19)
  datosCodere<-datosCodere[,!names(datosCodere) %in% c("context_data_event_time")]
  
  
  # ----------------------- Vamos a separar las sesiones del dataframe
  # Nos quedamos con una lista de sesiones
  sesiones <- unique(datosCodere$context_session_id)
  # [1] ++jfZ ++LcD +/106 +/oAU +/Tq1 +/z5o
  # 14620 Levels: //b1/ //Khq //o0Q //uzZ /+eaV /+ebd /+PHu /+rds /+Uel /07jZ /0FQL /0LDy ... zZxrb
  
  # ----------------------- Extraccion de Secuencias
  # Creamos data.table con las sesiones en formato conveniente, 
  # cada una con su correspondiente secuencia de pasos
  secuencias <- extraeSesiones(datosCodere, sesiones)
  # Tendremos una estructura:
  #      IdSesion               Secuencia       BetCompleted  Longitud
  #1:       ++jfZ   136, 183, 24, 149, 84                 25       848    
  #...
  

  # Creamos columna isAuthenticated en la que se indica si la navegación ha hecho login
  # o no en la sesión actual o en una anterior
  #
  # Empleamos «unlist» porque es necesaria una lista normal para copiarla
  # en un dataframe, no una lista de listas, que es lo que produce «lapply»
  secuencias$isAuthenticated <- 
    unlist(lapply(1:length(secuencias$Secuencia_authenticated),
                  function(i)
                    if(secuencias$authenticated[i] == 0)
                      return(0)
                  else
                    return(1)))
  
  return(secuencias)
}

####################################################################################
############################### CARGA DATOS ########################################
####################################################################################
# Conexión a la Base de Datos
BD <- conecta_BD()

# 1. Cargamos la tabla de codificacion de acciones:
tablaCodificacion <- sqlQuery(BD, 'select * from dbo.actions')

# 2. Cargamos las secuencias del dia 27/12:
#secuencias <- cargaSecuencias('select action_node, action_node_id, context_session_id, context_data_event_time, action_num_step from dbo.events_views where flag_load = \'S\' order by context_session_id, context_data_event_time')
#save.image("secuencias27-12.RData")
#rm(secuencias)

# 3. Cargamos las secuencias del dia 22/01:
secuencias <- cargaSecuencias('select action_node, action_node_id, context_session_id, context_data_event_time, context_user_is_authenticated, action_num_step 
                        from dbo.events_views_27_01 order by context_session_id, context_data_event_time')

# Guardamos el objeto secuencias
save.image("secuencias22-01.RData")
rm(secuencias)

# Cerramos conexion
close_BD(BD)

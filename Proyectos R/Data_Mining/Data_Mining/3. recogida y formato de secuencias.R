# ------------------------------------------------------------------
#
# Nombre de la funci�n: conecta_BD
#
# Descripci�n:
#
# Funci�n que configura el enlace con la base de datos de Azure
# En este caso, la Base de Datos se llama 
#
# Variables de entrada: Ninguna
#
# Variable de salida: Conector de la base de datos que se emplear�
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
  
  #Apertura de conexi�n
  dbconnector <- odbcDriverConnect(connectionString)
  return(dbconnector)
}


# ------------------------------------------------------------------
#
# Nombre de la funci�n: conecta_BD_produccion
#
# Descripci�n:
#
# Funci�n que configura el enlace con la base de datos de Azure de produccion
# En este caso, la Base de Datos se llama 
#
# Variables de entrada: Ninguna
#
# Variable de salida: Conector de la base de datos que se emplear�
# para lanzar peticiones.
#
#

conecta_BD_produccion <- function() {
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
     
     #Apertura de conexi�n
     dbconnector <- odbcDriverConnect(connectionString)
     return(dbconnector)
}




# ------------------------------------------------------------------
#
# Nombre de la funci�n: extraeSesiones
#
# Descripci�n:
# 
# Funci�n que recibe la informaci�n bruta de la Base de Datos y conforma
# una estructura de tipo �data.table� con las siguientes columnas:
#
# �IdSesion�: Identificador de la sesi�n.
# �Secuencia�: Secuencia de navegaci�n codificada y separada por comas.
# �BetCompleted�: N�mero de eventos tipo �BetCompleted� que contiene la secuencia.
# �Longitud�: Longitud de la secuencia
# �secuencia_authenticated�: Secuencia de isAuthenticated (false y/o true) separada por comas
# �authenticated�: N�mero de Authenticated a True
#
# Variables de entrada:
#
# �datosCodere�: Variable del tipo �data.frame� con datos en bruto de la
#                base de datos. En cada fila contiene un paso de navegaci�n.
# �sesiones�: Lista con los identificadores de todas las sesiones.
#
# Variable de salida: 
#
# Una estructura de datos del tipo �data.table�
#

extraeSesiones <- function(datosCodere, sesiones) {
     # Creamos dataframe vac�o que en principio tiene s�lo la columna de IdSesion
     datosCodereSesiones <- data.frame(IdSesion= character(),stringsAsFactors = F)
     
     # Creamos dataframe de trabajo para el bucle
     df <- datosCodereSesiones[0]
     
     # Para cada sesi�n
     for(ses in sesiones) {
          # A�ade una fila al dataframe df correspondiente a la sesi�n
          df <- rbind(df,
                      data.frame(IdSesion=ses,
                                 stringsAsFactors = F))
          # Recorremos el dataframe Datoscodere y recogemos todos los eventos
          # correspondientes a una sesi�n, en forma de lista
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
          # La primera vez que se hace, adem�s, se crea una nueva columna en el dataframe df
          df$Secuencia<-list(secuencia)
          df$Secuencia_authenticated<-list(secuencia_authenticated)
          datosCodereSesiones<-rbind(datosCodereSesiones,df)
          
          df <- datosCodereSesiones[0]
     }
     #print("columnas secuencias creadas")
     
     # El nombre de cada fila es el de la sesi�n
     rownames(datosCodereSesiones) <- sesiones
     
     # Creamos columna BetCompleted en la que se indica si la navegaci�n contiene o no un BetCompleted
     #
     # Empleamos �unlist� porque es necesaria una lista normal para copiarla
     # en un dataframe, no una lista de listas, que es lo que produce �lapply�
     datosCodereSesiones$BetCompleted <- 
          unlist(lapply(datosCodereSesiones$Secuencia, 
                        function(x) length(which(x == betCompleted))))
     
     
     # Creamos columna authenticated en la que se indica si la navegaci�n contiene o no un authenticated
     #
     # Empleamos �unlist� porque es necesaria una lista normal para copiarla
     # en un dataframe, no una lista de listas, que es lo que produce �lapply�
     datosCodereSesiones$authenticated <- 
          unlist(lapply(datosCodereSesiones$Secuencia_authenticated, 
                        function(x) length(which(x == "True"))))
     
     #print(datosCodereSesiones$authenticated)
     
     # El motivo del paso a data.table es que el rendimiento es mucho 
     # mayor que el del dataframe
     datosCodereSesiones <- as.data.table(datosCodereSesiones)
     
     # A�adimos un campo con la longitud
     datosCodereSesiones$Longitud<-sapply(datosCodereSesiones$Secuencia, length)
     
     return(datosCodereSesiones)
}











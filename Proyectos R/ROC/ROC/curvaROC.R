## Se determina la acción por la cual se va a calcular la curva ROC
## EN este caso ticket completado: betCompleted
betCompleted <- 90


## Cargamos las librerías
require(proxy)
require(tm)      # Funciones de minería de textos
require(slam)    # Función «crossprod_simple_triplet_matrix»
require(stringdist) # Función seq_distmatrix
require(RODBC)
require(rebus)

## Función de conexión con la BD para extraer las secuencias que se van a utilizar para
## calcular la curva ROC

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

# Nombre de la función: distJac
distJac <- function (x,y) {
     x <- unique(unlist(x[which(x!=0)]))
     y <- unique(unlist(y[which(y!=0)]))
     interseccion <- length(intersect(x,y))
     unido <- length(union(x,y))
     return(1-interseccion/unido)
}

# Nombre de la función: distLev
distLev <- function(x,y) {
     # Preparamos las secuencias
     listas <- list(as.vector(x),as.vector(y))
     # La función «seq_distmatrix» ya devuelve un objeto del tipo «dist»
     return(seq_distmatrix(listas, method = c("lv")))
}

# Nombre de la función: distMedioide
distMedioide <- function(medioide, secuencia, distancia) {
     return(ifelse(distancia=="Jac",distJac(medioide,secuencia),
                   ifelse(distancia=="Lev",distLev(medioide,secuencia),0)))
}

# Función que devuelve el cluster de cada sesión
devuelveCluster <- function (clusterizacion, secuencia){
     # Se recoge la posicion que ocupa el cluster que tiene la menor distancia entre el medioide y la secuencia.
     # Se presupone que todos los cluster de una clusterizacion han sido calculados con una de estas 2 distancias:
     # Jac --> Distancia Jaccard modificada
     # Lev --> Distancia Levehistein  
     distancia <- unique(clusterizacion$distancia)  
     pos.cluster <- which.min(lapply(clusterizacion$medioide,function(x){distMedioide(unlist(lapply(strsplit(as.character(x), ","),as.numeric)),secuencia,distancia)}))
     return(clusterizacion[pos.cluster,])
}

# Función extraeSesiones

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
     #datosCodereSesiones <- as.data.table(datosCodereSesiones)
     
     # Añadimos un campo con la longitud
     datosCodereSesiones$Longitud<-sapply(datosCodereSesiones$Secuencia, length)
     
     return(datosCodereSesiones)
}

## Extracción de las acciones de la tabla dbo.events_views.
## Se ejecuta el procedimiento almacenado que carga en la tabla dbo.sequencies_ROC 
## todas las acciones de n sesiones aleatorias.
BD <- conecta_BD()
sqlQuery(BD, "exec dbo.sessions_to_ROC")

## Se extraen las acciones de las n sesiones aleatorias que se han cargado en tabla
## dbo.sequencies_ROC
datasetSesionesAClusterizar <- 
     sqlQuery(BD, "Select * from dbo.sequencies_ROC")
#colnames(datasetSesionesAClusterizar

## Almacenamos en una variable la extracción que se ha hecho para utilizarla en futuros
## experimentos con otras variables objetivos u otros números de pasos
datasetSesionesAClusterizarOriginal <- datasetSesionesAClusterizar

## Almacenenamos en una variable los n primeros pasos de las sesiones:
## action_node_num_step <= n
datasetSesionesAClusterizarMitad <- 
     datasetSesionesAClusterizarOriginal[datasetSesionesAClusterizarOriginal$action_node_num_step<= 25,]

#head(datasetSesionesAClusterizarMitad)

close(BD)

###### datasetSesionesAClusterizarMitad #################################
#
#
#
# Separación de la fecha y la hora
datasetSesionesAClusterizarMitad$fecha <- 
     substring(datasetSesionesAClusterizarMitad$context_data_event_time, 1, 10)
datasetSesionesAClusterizarMitad$hora <- 
     substring(datasetSesionesAClusterizarMitad$context_data_event_time, 12, 19)
datasetSesionesAClusterizarMitad<-
     datasetSesionesAClusterizarMitad[,!names(datasetSesionesAClusterizarMitad) %in% c("context_data_event_time")]

# sesiones es un vector con los id de todas y cada una de las sesiones
sesiones <- unique(datasetSesionesAClusterizarMitad$context_session_id)
#print("creamos data.frame secuencias")
# Creamos data.frame con las sesiones en formato conveniente
secuencias <- extraeSesiones(datasetSesionesAClusterizarMitad, sesiones)

# Status: Si hay o no BetCompleted. Si lo hay, Status vale 1, 
# en el otro caso vale 0.
secuencias$Status <- 
     unlist(lapply(1:length(secuencias$Secuencia),
                   function(i)
                        if(secuencias$BetCompleted[i] == 0)
                             return(0)
                   else
                        return(1)))

#print("status creado")          

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

#print("Secuencias authenticated")
#print(secuencias$isAuthenticated)

# Se crea la columna secuencia aparte ya que es un vector y es necesario convertirla a string
secuencia.column.df <- data.frame(secuencias["Secuencia"])
secuencia.column <- 
     as.data.frame(apply(secuencia.column.df, 1, function(x) paste(x[[1]], collapse = ", ")))
colnames(secuencia.column) <- "Secuencia"
#head(secuencias$Secuencia)

# Creamos el dataframe secuencias.output que será el devuelva el servicio
secuencias.output <- secuencias[,c(1,4,6,8)]
secuencias.output <- cbind(secuencias.output, secuencia.column)
datasetSesionesAClusterizarMitad <- secuencias.output
#head(datasetSesionesAClusterizarMitad)

## Extracción de los medioides de cada cluster de la tabla dbo.clusters.
BD <- conecta_BD()
datasetClusterizaciones <- 
     sqlQuery(BD, 
              'select name_clusterizacion,distancia,name_cluster,
              medioide,num_sesiones_apostantes_cluster,num_sesiones_cluster from dbo.clusters')

close(BD)

## Calculamos el ratio de apostantes de cada cluster
datasetClusterizaciones$ratio_apostantes <- 
     (datasetClusterizaciones$num_sesiones_apostantes_cluster/datasetClusterizaciones$num_sesiones_cluster)

nameClusterizaciones <- unique(datasetClusterizaciones$name_clusterizacion)
#nameClusterizaciones
df.adnClientesMitad <- data.frame()

# Para cada secuencia, vamos a hallar su cluster más próximo de cada clusterización
# y la iremos incluyendo en un data frame de adnCliente
for(pos_sec in c(1:dim(datasetSesionesAClusterizarMitad)[1])){
     # Recogemos la secuencia de acciones y la convertimos a vector
     secuenciaSolicitada <- unlist(lapply(strsplit(as.character(datasetSesionesAClusterizarMitad[pos_sec,]$Secuencia), split=","),as.numeric))
     
     # Recogemos la sesión
     session_id <- datasetSesionesAClusterizarMitad[pos_sec,]$IdSesion
     
     # Data frame que tendra la secuencia con cada una de los clusteres a los que pertenece
     df.adnClienteMitad <- data.frame()
     
     # Para cada clusterizacion calculo con respecto a su distancia (Lev o Jac)
     # cual seria el cluster apropiado para la secuencia de entrada
     for(name in nameClusterizaciones){
          clusterAjustado <- devuelveCluster(datasetClusterizaciones[datasetClusterizaciones$name_clusterizacion==name,],secuenciaSolicitada)
          # Como salida tenemos el cluster al que pertenece la secuencia solicitada de la clusterizacion con nombre 'name'
          
          # La incluimos en el ADN del cliente
          secuencia <- data.frame(session_id=session_id, secuencia=toString(secuenciaSolicitada), name_clusterizacion=clusterAjustado$name_clusterizacion, name_cluster=clusterAjustado$name_cluster)
          df.adnClienteMitad <- rbind(df.adnClienteMitad,secuencia)
     }
     
     # Incluimos en el ADN de todos los clientes
     df.adnClientesMitad <- rbind(df.adnClientesMitad,df.adnClienteMitad) 
}

#head(df.adnClientesMitad)

###### datasetSesionesAClusterizar
#
# Se extraen los k siguientes pasos en los que se va a hacer la predicción
# action_node_num_step > n
# action_node_num_step <= n + k
datasetSesionesAClusterizar <- datasetSesionesAClusterizarOriginal
datasetSesionesAClusterizar <- 
     datasetSesionesAClusterizar[datasetSesionesAClusterizar$action_node_num_step > 25,]
datasetSesionesAClusterizar <- 
     datasetSesionesAClusterizar[datasetSesionesAClusterizar$action_node_num_step <= 30,]
# Separación de la fecha y la hora
datasetSesionesAClusterizar$fecha <- 
     substring(datasetSesionesAClusterizar$context_data_event_time, 1, 10)
datasetSesionesAClusterizar$hora <- 
     substring(datasetSesionesAClusterizar$context_data_event_time, 12, 19)
datasetSesionesAClusterizar<-
     datasetSesionesAClusterizar[,!names(datasetSesionesAClusterizar) %in% c("context_data_event_time")]
head(datasetSesionesAClusterizar$Secuencia)
# sesiones es un vector con los id de todas y cada una de las sesiones
sesiones <- unique(datasetSesionesAClusterizar$context_session_id)
#print("creamos data.frame secuencias")
# Creamos data.frame con las sesiones en formato conveniente
secuencias <- extraeSesiones(datasetSesionesAClusterizar, sesiones)

# Status: Si hay o no BetCompleted. Si lo hay, Status vale 1, 
# en el otro caso vale 0.
secuencias$Status <- 
     unlist(lapply(1:length(secuencias$Secuencia),
                   function(i)
                        if(secuencias$BetCompleted[i] == 0)
                             return(0)
                   else
                        return(1)))

#print("status creado")          

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

#print("Secuencias authenticated")
#print(secuencias$isAuthenticated)

# Se crea la columna secuencia aparte ya que es un vector y es necesario convertirla a string
secuencia.column.df <- data.frame(secuencias["Secuencia"])
secuencia.column <- 
     as.data.frame(apply(secuencia.column.df, 1, function(x) paste(x[[1]], collapse = ", ")))
colnames(secuencia.column) <- "Secuencia"
#head(secuencias)

# Creamos el dataframe secuencias.output que será el devuelva el servicio
secuencias.output <- secuencias[,c(1,4,6,8)]
secuencias.output <- cbind(secuencias.output, secuencia.column)
datasetSesionesAClusterizar <- secuencias.output
#head(datasetSesionesAClusterizar)


## Se añade una columna con el valor real de la apuesta 1 ó 0.
#df.adnClientesMitad

sesionesROC <- df.adnClientesMitad[,c(1,4)]
clustersApuestas <- datasetClusterizaciones[,c(2,3,7)]
#clustersApuestas.Lev <- clustersApuestas[clustersApuestas$distancia == "Lev",]
clustersApuestas.Jac <- clustersApuestas[clustersApuestas$distancia == "Jac",]

# Nos quedamos con los campos del dataframe que necesitamos
sesionesApostantes <- secuencias[,c(1,7)]

#sesionesROC
#clustersApuestas.Jac
#clustersApuestas.Lev
#sesionesApostantes

## Hacemos un merge para almacenar en un sólo dataframe todas las variables necesarias para 
## calcular la curva ROC
sesionesROC.Jac <- merge(x = sesionesROC, y = sesionesApostantes, by.x = "session_id", by.y = "IdSesion")
sesionesROC.Jac <- merge(x = sesionesROC.Jac, y = clustersApuestas.Jac, by.x = "name_cluster", by.y = "name_cluster")
#sesionesROC.Jac

#sesionesROC.Lev <- merge(x = sesionesROC, y = sesionesApostantes, by.x = "session_id", by.y = "IdSesion")
#sesionesROC.Lev <- merge(x = sesionesROC.Lev, y = clustersApuestas.Lev, by.x = "name_cluster", by.y = "name_cluster")
#sesionesROC.Lev

## Se añade otra columna con el la porcentaje de probabilidad de la apuesta.

## Se calcula la curva ROC

library(rpart)
## install.packages("pROC")
library(pROC)
library(ggplot2)


ROCJac <- roc(sesionesROC.Jac$Status, sesionesROC.Jac$ratio_apostantes)
plot(ROCJac, col = "blue", xlim = c(1,0))

#ROCLev <- roc(sesionesROC.Lev$Status, sesionesROC.Lev$ratio_apostantes)
#plot(ROCLev, col = "blue")


AUCJac <- auc(ROCJac)
AUCJac

#AUCLev <- auc(ROCLev)
#AUCLev

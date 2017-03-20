################################################################################################################
############################# CARGAS DE DATOS SEMANAL  ###########################################################
################################################################################################################
#  En este fichero realizaremos la carga de los datos de una semana completa
################################################################################################################
################################################################################################################


rm(list=ls())
setwd("D:/Pedro/Master MBIT/Proyecto Master/PROYECTO CODERE/Exploracion Datos/Data Mining/Cargas de Datos")
ficheros <- list.files()

is.installed <- function(paquete) is.element (
  paquete, installed.packages())

if(!is.installed("data.table"))
  install.packages("data.table")

require(data.table)



betCompleted <- 90

devuelveDiaSemana <- function (dia){
  switch(dia, 
         "2017-01-23"={
           return('L')
         },
         "2017-01-24"={
           return('M')    
         },
         "2017-01-25"={
           return('X')    
         },
         "2017-01-26"={
           return('J')    
         },
         "2017-01-27"={
           return('V')    
         },
         "2017-01-21"={
           return('S')    
         },
         "2017-01-22"={
           return('D')    
         },
         {
           return('default')
         }
  )
}

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
    
    # Añadimos la fecha y el dia de la semana
    # IMP: Si una sesion tiene dos fechas porque ha cambiado de dia durante la navegacion
    # se coge la primera
    fecha <- datosCodere[datosCodere$context_session_id==ses,]$fecha
    df$fecha <- unique(fecha)[1]
    df$diaSemana <- devuelveDiaSemana(unique(fecha)[1])
    
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







datosCodere_prod_semana <- readRDS("D:/Pedro/Master MBIT/Proyecto Master/PROYECTO CODERE/Exploracion Datos/Data Mining/Matrices metricas proyecto/datosCodere_prod_semana.rds")
dim(datosCodere_prod_semana)[1]

# Revisamos las diferentes fechas
unique(datosCodere_prod_semana$fecha)
dim(datosCodere_prod_semana[datosCodere_prod_semana$fecha=="2017-01-19",])[1] # J
dim(datosCodere_prod_semana[datosCodere_prod_semana$fecha=="2017-01-20",])[1] # V
dim(datosCodere_prod_semana[datosCodere_prod_semana$fecha=="2017-01-21",])[1] # S
dim(datosCodere_prod_semana[datosCodere_prod_semana$fecha=="2017-01-22",])[1] # D
dim(datosCodere_prod_semana[datosCodere_prod_semana$fecha=="2017-01-23",])[1] # L
dim(datosCodere_prod_semana[datosCodere_prod_semana$fecha=="2017-01-24",])[1] # M
dim(datosCodere_prod_semana[datosCodere_prod_semana$fecha=="2017-01-25",])[1] # X
dim(datosCodere_prod_semana[datosCodere_prod_semana$fecha=="2017-01-26",])[1] # J
dim(datosCodere_prod_semana[datosCodere_prod_semana$fecha=="2017-01-27",])[1] # V

# Quitamos las sesiones del 19/01 y 20/01 que no tiene sentido
datosCodere_prod_semana <- datosCodere_prod_semana[which(!datosCodere_prod_semana$fecha %in% c("2017-01-19","2017-01-20")),]
dim(datosCodere_prod_semana)[1]

# Nos quedamos con una muestra (TEMPORAL)
#datosCodere_prod_semana <- datosCodere_prod_semana[1:3000,]
#datosCodere_prod_semana
#datosCodere_prod_semana[,c("context_session_id","fecha")]

# ----------------------- Vamos a separar las sesiones del dataframe
# Nos quedamos con una lista de sesiones
sesiones <- unique(datosCodere_prod_semana$context_session_id)

# ----------------------- Extraccion de Secuencias
# Creamos data.table con las sesiones en formato conveniente, 
# cada una con su correspondiente secuencia de pasos
secuencias <- extraeSesiones(datosCodere_prod_semana, sesiones)


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

# Nos quitamos columnas de calculo que ya no vamos a utilizarlas:
secuencias<-secuencias[,!names(secuencias) %in% c("Secuencia_authenticated")]
head(secuencias,20)

# Guardamos el objeto secuencias
save.image("secuenciasSemana.RData")
rm(secuencias)
rm(datosCodere_prod_semana)

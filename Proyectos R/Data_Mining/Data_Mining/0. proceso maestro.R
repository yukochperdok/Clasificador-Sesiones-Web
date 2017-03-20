
# 
# Secuencia de proceso maestro
#

setwd("C:/Users/Carlos/Documents/Máster/Proyecto/Codere/Datos/scripts_finales/OneDrive")

print("1. Cargando bibliotecas ...")
invisible(source("1. bibliotecas.R"))

print("2. Cargando constantes y funciones globales ...")
invisible(source("2. constantes y funciones globales.R"))


# -------------------- Cálculo de las matrices métricas

print("3. Cargando datos y dando formato ...")
invisible(source("3. recogida y formato de secuencias.R"))

invisible(
    if(is.null(datosCodere <- carga("datosCodere", dirMatricesMetricas))) {
      BD <- conecta_BD_produccion()
      datosCodere <- 
         sqlQuery(BD, 'select action_node, action_node_id, context_session_id, 
                          context_data_event_time, action_num_step, context_user_is_authenticated 
                       from dbo.events_views
                       order by context_session_id, context_data_event_time')
      
      # Separación de la fecha y la hora
      datosCodere$fecha <- substring(datosCodere$context_data_event_time, 1, 10)
      datosCodere$hora <- substring(datosCodere$context_data_event_time, 12, 19)
      datosCodere<-datosCodere[,!names(datosCodere) %in% c("context_data_event_time")]
      
    }

)

invisible(
    if(is.null(tablaCodificacion <- carga("tablaCodificacion", 
                                          dirMatricesMetricas))) {
      
      # Tabla con la equivalencia de cada código de navegación
      BD <- conecta_BD_produccion()
      tablaCodificacion <- sqlQuery(BD, 'select * from dbo.actions')
      saveRDS(tablaCodificacion, 'tablaCodificacion.rds')
    }
)

invisible(
    if(is.null(sesiones <- carga("sesiones", 
                                 dirMatricesMetricas))) {
      
      # sesiones es un vector con los id de todas y cada una de las sesiones
      sesiones <- unique(datosCodere$context_session_id)
      saveRDS(tablaCodificacion, 'sesiones.rds')
    }
)

invisible(
    if(is.null(secuencias <- carga("secuencias", 
                                   dirMatricesMetricas))) {
      
      # Creamos data.table con las sesiones en formato conveniente
      secuencias <- extraeSesiones(datosCodere, sesiones)
    
      # Status: Si hay o no BetCompleted. Si lo hay, Status vale 1, 
      # en el otro caso vale 0.
      secuencias$Status <- 
        unlist(lapply(1:length(secuencias$Secuencia),
                      function(i)
                        if(secuencias$BetCompleted[i] == 0)
                          return(0)
                        else
                          return(1)))
      
      # Si hay BetCompleted, vale el paso en el que BetCompleted tiene lugar.
      # Si no hay BetCompleted, vale la longitud de la navegación.
      secuencias$PasoNavegacion <- unlist(
        lapply(1:length(secuencias$Secuencia),
               function(i)
                 match(betCompleted, 
                       secuencias$Secuencia[[i]], 
                       nomatch = secuencias$Longitud[i])))
      
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
    }
)


print("4. Cargando limpieza datos ...")
invisible(source("4. limpieza datos.R"))

# Hago un muestreo de 24000 secuencias del dataframe secuencias
# secuencias <- secuencias[sample(nrow(secuencias), 24000), ]
nrow(secuencias)


print("5. Cargando matriz de navegacion ...")
invisible(source("5. matriz de navegacion.R"))

invisible(
    if(is.null(matrizClicks <- carga("matrizClicks", 
                                     dirMatricesMetricas))) {
    
      # muestra <- secuencias[sample(.N, 1000)]
      # matrizClicks <- creaMatrizNavegacion(muestra, tablaCodificacion$action_node_id)
      matrizClicks <- 
        creaMatrizNavegacion(secuencias, 
                             tablaCodificacion$action_node_id)
    }
)
print("6. Cargando métricas y agrupamientos ...")
invisible(source("6. metrica y agrupamiento.R"))

# Vemos las posiciones de listaDistancias que están sin ocupar
posVacias <- 
  c(1:length(listaDistancias))[sapply(listaDistancias, 
                                      function(i) i[1] == -1)]

invisible(
    for(i in posVacias) {
      
      if(is.null(matrizMetrica <- 
                 carga(paste0(nombreMatrizMetrica, 
                              nombresDistancias[i]), 
                       dirMatricesMetricas))) {
          print(paste("No existe en disco la matriz métrica de", 
                      nombresDistanciasCompletos[i]))
          print(paste("El cálculo de la matriz métrica de", 
                      nombresDistanciasCompletos[i],"dura unas 24 h"))
          respuesta <- readline("¿Desea continuar? (Y/N)")
          
          if(toupper(respuesta) == "Y") {
            switch(i, 
                   Jaccard = {
                     listaDistancias[[i]] <- 
                       dist(matrizClicks, method = distJac)
                   },
                   TfIdf = {
                     listaDistancias[[i]] <- 
                       distTfIdf(matrizClicks, evPocoSignif)
                   },
                   Levenshtein = {
                     listaDistancias[[i]] <- 
                       distLev(matrizClicks)
                   })
          }
      } else {
           print("listadistancias")
        # Si existe en memoria la matriz métrica la colocamos 
        # en su sitio
        listaDistancias[[i]] <- matrizMetrica
        
        # Se borra el objeto
        rm(matrizMetrica)
        
        # Se libera memoria
        gc()
      }
    }
)

print(paste0("Memoria utilizada: ", memory.size()))

# -------------------- Carga de agrupaciones. Ejemplos: Jac5, TfIdf8
invisible(
    for(i in 1:numDistancias) {
      for(j in 1:numDimensiones) {
        print(names(listaGrupos[(i - 1) * numDimensiones + j]))
        if(is.null(objeto <- 
                   carga(names(listaGrupos[(i - 1) * numDimensiones + j]), 
                         dirMatricesMetricas))) {
          print(paste0("calculamos ", nombreGrupos, 
                       nombresDistancias[i], tamanosGrupos[j]))
             print(i)
          listaGrupos[(i - 1) * numDimensiones + j] <- 
            list(pam(listaDistancias[[i]], j, diss=TRUE))
          print("cargado")
        } else {
          print(paste0("Cargamos en memoria ", nombreGrupos, 
                       nombresDistancias[i], tamanosGrupos[j]))
          listaGrupos[(i - 1) * numDimensiones + j] <- list(objeto)
          
          # Se borra el objeto
          rm(objeto)
        }
      }
      
      # Se libera memoria
      gc()
    }
)
# -------------------- Extracción de grupos. Dada una agrupación (Jac5, o TfIdf8), los
#                      grupos son cada uno de los segmentos en los que se ha dividido
#                      la muestra. Jac5 tiene 5 grupos, Lev11 tiene 11 grupos.
#                      Se trata de una tarea casi instantánea, por tanto se extraen
#                      directamente de la agrupación que ya está en memoria.

invisible(
    for(i in 1:numDistancias) {
      pos <- 0
      for(j in tamanosGrupos) {
        pos <- pos + 1
        for (k in 1:j) {
          #cadena <- nombreSecuencias
          #cadena <- paste0(cadena, "[", nombreGrupos, nombresDistancias[i], 
          #                 j,"$clustering == ", k, ",]")
          cadena <- 
            paste0("secuencias[listaGrupos[[", 
                   length(tamanosGrupos) * (i-1) + match(j, tamanosGrupos),
                   "]]$clustering ==", k, ",]")
          listaSubGrupos[(i - 1) * sum(tamanosGrupos) +
                          sum(tamanosGrupos[1:pos-1])+k] <- 
            list(evalua(cadena))
        }
      }
    }
)

# Representaciones gráficas de agrupaciones
# graficaClusters(matrizClicks, "Jac", 8, 1000, TRUE, tablaCodificacion)
# graficaClusters(matrizClicks, "Jac", 11, 1000, TRUE, tablaCodificacion)


print("7. Generando tabla de salida")
source("7. indicadores.R")
#source("8. Tabla de salida.R")

#invisible(
#    for(i in 1:numDistancias) {
#      for(j in 1:numDimensiones) {
#          kk <- proc.time()
#          print(paste0("Cargamos en memoria ", nombreTablas, 
#                       nombresDistancias[i], tamanosGrupos[j]))
#          listaTablas[(i - 1) * numDimensiones + j] <- 
#            list(creaResultados(tablaSalida, matrizClicks, 
#                                nombresDistancias[i], 
#                                tamanosGrupos[j]))
#          print(proc.time() - kk)
#      }
#    }
#)

# Generación del dataframe adhoc para a tabla de la BD dbo.clusters
# Se incluye la carga del dataframe 

source("9. tabla de salida bd.R")

invisible(
     for(i in 1:numDistancias) {
          for(j in 1:numDimensiones) {
               kk <- proc.time()
               print(paste0("Cargamos en memoria ", nombreTablas, 
                            nombresDistancias[i], tamanosGrupos[j]))
               listaTablas[(i - 1) * numDimensiones + j] <- 
                    list(creaResultadosBD(tablaSalidaBD, matrizClicks, 
                                        nombresDistancias[i], 
                                        tamanosGrupos[j]))
               print(proc.time() - kk)
          }
     }
)

# Carga de la tabla dbo.clusters
con <- conecta_BD_produccion()

sqlSave(con, listaTablas$tablasSalidaLev11, tablename =
             "dbo.clusters",rownames=FALSE, append = TRUE)

close(con)

listaTablas$tablasSalidaJac8


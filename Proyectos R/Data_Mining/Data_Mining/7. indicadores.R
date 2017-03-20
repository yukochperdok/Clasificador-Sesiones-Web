#
# Primer indicador
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

mediaSecuenciasBetCompleted <- function(seqs) {
#  return(round(mean(seqs[seqs[["BetCompleted"]]!=0][["BetCompleted"]]), 2))
#  return(round(mean(seqs[seqs[["BetCompleted"]]!=0]$BetCompleted), 2))
   return(round(mean(seqs[seqs$BetCompleted!=0,]$BetCompleted), 2))
  
}

# ------------------------------------------------------------------
#
# Nombre de la función: numApuestas
#
# Descripción:
#
# Devuelve la suma de «BetCompleted» que hay en las secuencias que 
# hay en «seqs». 
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Número de «BetCompleted» totales
#
# Ejemplos de llamada:
#
# numApuestas(secuencias[1,])        # Primera secuencia
# numApuestas(secuencias[1:7,])      # Secuencias de 1 a 7
# numApuestas(secuencias[c(1,3,7),]) # Secuencias 1, 3 y 7
# numApuestas(secuencias)            # Todas las secuencias

numApuestas <- function(seqs) {
#  return(sum(seqs[seqs$BetCompleted>=1]$BetCompleted))
  return(sum(seqs[seqs$BetCompleted>=1,]$BetCompleted))
}

# ------------------------------------------------------------------
#
# Nombre de la función: numApostantes
#
# Descripción:
#
# Devuelve el numero de secuencias que al menos han apostado una vez. 
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Número de secuencias que tienen BetCompleted
#
# Ejemplos de llamada:
#
# numApostantes(secuencias[1,])        # Primera secuencia
# numApostantes(secuencias[1:7,])      # Secuencias de 1 a 7
# numApostantes(secuencias[c(1,3,7),]) # Secuencias 1, 3 y 7
# numApostantes(secuencias)            # Todas las secuencias

numApostantes <- function(seqs) {
  # return(length(seqs[seqs$BetCompleted>=1]$BetCompleted))
    return(length(seqs[seqs$BetCompleted>=1,]$BetCompleted))
}



# ------------------------------------------------------------------
#
# Nombre de la función: numNOApostantes
#
# Descripción:
#
# Devuelve el numero de secuencias que no han apostado ninguna vez. 
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Número de secuencias que NO tienen ningun BetCompleted
#
# Ejemplos de llamada:
#
# numNOApostantes(secuencias[1,])        # Primera secuencia
# numNOApostantes(secuencias[1:7,])      # Secuencias de 1 a 7
# numNOApostantes(secuencias[c(1,3,7),]) # Secuencias 1, 3 y 7
# numNOApostantes(secuencias)            # Todas las secuencias

numNOApostantes <- function(seqs) {
#  return(length(seqs[seqs$BetCompleted==0]$BetCompleted))
  return(length(seqs[seqs$BetCompleted==0,]$BetCompleted))
}

# ------------------------------------------------------------------
#
# Nombre de la función: porcentajeApostantes
#
# Descripción:
#
# Devuelve el porcentaje de apostantes en el total de las secuencias
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Núm secuencias que tienen algun <<BetCompleted>> / Núm total secuencias
#
# Ejemplos de llamada:
#
# porcentajeApostantes(secuencias[1,])        # Primera secuencia
# porcentajeApostantes(secuencias[1:7,])      # Secuencias de 1 a 7
# porcentajeApostantes(secuencias[c(1,3,7),]) # Secuencias 1, 3 y 7
# porcentajeApostantes(secuencias)            # Todas las secuencias

porcentajeApostantes <- function(seqs) {
  return(round(numApostantes(seqs)/dim(seqs)[1]*100, 2))
}

# ------------------------------------------------------------------
#
# Nombre de la función: porcentajeNOApostantes
#
# Descripción:
#
# Devuelve el porcentaje de NO apostantes en el total de las secuencias
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Núm secuencias que NO tienen ningun <<BetCompleted>> / Núm total secuencias
#
# Ejemplos de llamada:
#
# porcentajeNOApostantes(secuencias[1,])        # Primera secuencia
# porcentajeNOApostantes(secuencias[1:7,])      # Secuencias de 1 a 7
# porcentajeNOApostantes(secuencias[c(1,3,7),]) # Secuencias 1, 3 y 7
# porcentajeNOApostantes(secuencias)            # Todas las secuencias

porcentajeNOApostantes <- function(seqs) {
  return(round(numNOApostantes(seqs)/dim(seqs)[1]*100, 2))
}

# ------------------------------------------------------------------
#
# Nombre de la función: numAuthenticateds
#
# Descripción:
#
# Devuelve el numero de secuencias que están autenticadas
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Número de secuencias que tienen isAuthenticated a true
#

numAuthenticateds <- function(seqs) {
     # return(length(seqs[seqs$BetCompleted>=1]$BetCompleted))
     return(length(seqs[seqs$authenticated>=1,]$authenticated))
}

# ------------------------------------------------------------------
#
# Nombre de la función: porcentajeAuthenticateds
#
# Descripción:
#
# Devuelve el porcentaje de authenticateds en el total de las secuencias
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Núm secuencias que tienen algún <<authenticated>> a true / Núm total secuencias
#

porcentajeAuthenticateds <- function(seqs) {
     return(round(numAuthenticateds(seqs)/dim(seqs)[1]*100, 2))
}



# ------------------------------------------------------------------
#
# Nombre de la función: mediaApuestasPorPersonas
#
# Descripción:
#
# Devuelve el promedio de numero de «betCompleted» por el total de sesiones que apuestan
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Núm total «BetCompleted»  / Núm secuencias que tienen algun <<BetCompleted>> 
#
# Ejemplos de llamada:
#
# mediaApuestasPorPersonas(secuencias[1,])        # Primera secuencia
# mediaApuestasPorPersonas(secuencias[1:7,])      # Secuencias de 1 a 7
# mediaApuestasPorPersonas(secuencias[c(1,3,7),]) # Secuencias 1, 3 y 7
# mediaApuestasPorPersonas(secuencias)            # Todas las secuencias

mediaApuestasPorPersonas <- function(seqs) {
  return(round(numApuestas(seqs)/numApostantes(seqs), 2))
}

histogramasCluster <- function(seqs) {
  seqs[["Grupo"]] <- 
    cut(seqs$Longitud, 
        c(0,20,40,60,80,100, max(seqs$Longitud)))
  grafoMultiple <- list(
    ggplot() + geom_bar(data = seqs,
                        aes(x=factor(Grupo),
                            fill=factor(Status)))
             + xlab("Long. navegación")
             + ylab("frec absoluta")
             + scale_fill_discrete("BetCompleted",
                        labels = c("No apuesta", "Apuesta")),
    ggplot() + geom_bar(data = secuencias,
                      aes(x=factor(Grupo),
                          fill=factor(Status)),
                      position = "fill")
             + xlab("Long. navegación")
             + ylab("proporción")
             + scale_fill_discrete("BetCompleted",
                        labels = c("No apuesta", "Apuesta")))

  marrangeGrob(grafoMultiple, nrow=1, ncol = 2, 
             top = "Proporción BetCompleted según longitud navegación")
}



#
# Segundo indicador
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
# ratioPrimero_BetCompleted(secuencias$Secuencia, addBet)
# ratioPrimero_BetCompleted(secuencias$Secuencia, closeBet)
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
# ratioSecuenciasPrimero_BetCompleted(secuencias, closeBet)
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
    lista <<-as.list(ratioPrimero_BetCompleted(secs[["Secuencia"]], 
                                               primero))
    media <- round(mean(unlist(lista), na.rm=TRUE), 2) 
    return(media)
  }  
  else {
    lista <<-as.list(ratioPrimero_BetCompleted(secs[["Secuencia"]], 
                                               primero))
    media <- round(mean(unlist(lista), na.rm=TRUE), 2)
    return(media)
  }
}


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
# acumuladorDeportesTotales
#
# Descripción:
#
# Calcula el número de apuestas NETAS y EFECTIVAS realizadas
# de todas las secuencias sin clusterizar.
#
# NOTA 1: NETAS significa que se descuentan aquellas apuestas
#         que han sido borradas por el apostante.
#
# NOTA 2: EFECTIVAS significa que sólo se consideran aquellas
#         apuestas que han concluido con un «betCompleted».
#
# «acumulaDeportesTotales» entrega el resultado de sus cálculos en una 
# variable global llamada «contadoresTotales». He aquí un ejemplo del 
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
# invisible(acumuladorDeportesTotales(secuencias$Secuencia, listaDeportes)) 
#
# Acumula las primeras 100 secuencias
# invisible(acumuladorDeportesTotales(secuencias$Secuencia[1:100], listaDeportes)) 
#
# Acumula las secuencias 1, 7 y 17
# invisible(acumuladorDeportesTotales(secuencias$Secuencia[c(1,7,17)], listaDeportes)) 
# ---------------------------------------------

acumuladorDeportesTotales <- function(secs, listaDep) {
     
     # Aplanamos la lista de deportes. Es útil para hacer búsquedas
     elementos <- unlist(listaDep)
     
     # Iteramos para cada secuencia
     sapply(secs, function(sec) {
          
          # Sólo se sigue si hay «betCompleted» en la secuencia
          if(!is.na(match(betCompleted, sec))) {
               # print(cat("-->", sec))
               # Limpiamos secuencia de elementos que no estén en la lista 
               # de deportes
               sec <- sec[which(sapply(sec, function(x) x %in% 
                                            unlist(list(elementos, betCompleted))))]
               #print(cat("-->>>>>", sec))
               # Se corta la secuencia según el patron definido por betCompleted
               # en tantas subsecuencias como «betCompleted» haya.
               subSecs <- patronBetCompleted(sec, betCompleted)
               #print(subSecuencias)
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
                              #print(deporte)
                              # Si no se trata de un evento de borrado de apuesta
                              if(deporte != "borrado") { 
                                   #print("incrementamos")
                                   # Incrementamos el contador correspondiente en la matriz de contadores
                                   contadoresTotales[1, deporte] <<- contadoresTotales[1, deporte] + 1
                                   contadoresTotales[1,"deporteAnterior"] <<- match(deporte, columnasDeportes)
                                   
                                   # Si se trata de un evento de borrado de apuesta
                              } else {  
                                   #print("decrementamos")
                                   # Decrementamos el contador del deporte anterior
                                   deporteAnterior <- columnasDeportes[contadoresTotales[[1,"deporteAnterior"]]]
                                   contadoresTotales[1, "deporteAnterior"] <<- contadoresTotales[1, "deporteAnterior"] - 1
                              }
                         }
                    })
               })
          }
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

reinicioContadoresTotales <- function () 
  invisible(
    lapply(1:dim(contadoresTotales)[2], 
           function(i) contadoresTotales[1,i] <<- 0))

#
# Cuarto Indicador
#
# % logados y no logados
#
# ------------------------------------------------------------------
#
# Nombre de la función: numLogados
#
# Descripción:
#
# Devuelve el numero secuencias que en algun momento se logan. 
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Número de secuencias que al menos tienen un LoginOK
#
# Ejemplos de llamada:
#
# numLogados(secuencias[1,])        # Primera secuencia
# numLogados(secuencias[1:7,])      # Secuencias de 1 a 7
# numLogados(secuencias[c(1,3,7),]) # Secuencias 1, 3 y 7
# numLogados(secuencias)            # Todas las secuencias

numLogados <- function(seqs) {
  return(length(which(unlist(lapply(seqs$Secuencia, 
                                    function(x){
                                      189 %in% x
                                    })))))
}


# ------------------------------------------------------------------
#
# Nombre de la función: numNOLogados
#
# Descripción:
#
# Devuelve el numero secuencias que en ningun momento se logan. 
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Número de secuencias que no tienen ningun LoginOK
#
# Ejemplos de llamada:
#
# numNOLogados(secuencias[1,])        # Primera secuencia
# numNOLogados(secuencias[1:7,])      # Secuencias de 1 a 7
# numNOLogados(secuencias[c(1,3,7),]) # Secuencias 1, 3 y 7
# numNOLogados(secuencias)            # Todas las secuencias

numNOLogados <- function(seqs) {
  return(length(which(unlist(lapply(seqs$Secuencia, 
                                    function(x){
                                      !(189 %in% x)
                                    })))))
}

# ------------------------------------------------------------------
#
# Nombre de la función: porcentajeLogados
#
# Descripción:
#
# Devuelve el porcentaje de logados en el total de las secuencias
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Núm secuencias que tienen algun <<LoginOK>> / Núm total secuencias
#
# Ejemplos de llamada:
#
# porcentajeLogados(secuencias[1,])        # Primera secuencia
# porcentajeLogados(secuencias[1:7,])      # Secuencias de 1 a 7
# porcentajeLogados(secuencias[c(1,3,7),]) # Secuencias 1, 3 y 7
# porcentajeLogados(secuencias)            # Todas las secuencias

porcentajeLogados <- function(seqs) {
  return(round(numLogados(seqs)/dim(seqs)[1]*100, 2))
}

# ------------------------------------------------------------------
#
# Nombre de la función: porcentajeNOLogados
#
# Descripción:
#
# Devuelve el porcentaje de NO logados en el total de las secuencias
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Núm secuencias que NO tienen ningun <<LoginOK>> / Núm total secuencias
#
# Ejemplos de llamada:
#
# porcentajeNOLogados(secuencias[1,])        # Primera secuencia
# porcentajeNOLogados(secuencias[1:7,])      # Secuencias de 1 a 7
# porcentajeNOLogados(secuencias[c(1,3,7),]) # Secuencias 1, 3 y 7
# porcentajeNOLogados(secuencias)            # Todas las secuencias

porcentajeNOLogados <- function(seqs) {
  return(round(numNOLogados(seqs)/dim(seqs)[1]*100, 2))
}

#
# numStreamings
#
# ------------------------------------------------------------------
#
# Nombre de la función: numStreamings
#
# Descripción:
#
# Devuelve el numero secuencias que en algun momento hacen streaming. 
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Número de secuencias que al menos tienen un ActivateDesStreaming

numStreamings <- function(seqs) {
     return(length(which(unlist(lapply(seqs$Secuencia, 
                                       function(x){
                                            ActivateDesStreaming %in% x
                                       })))))
}


#
# Quinto Indicador
#
# Promedio longitudes
#
# ------------------------------------------------------------------
#
# Nombre de la función: longitudMedia
#
# Descripción:
#
# Devuelve la longitud media de las secuencias
#
# Variables de entrada: 
#
# «seqs»: Dataframe o Datatable de secuencias
#
# Variable de salida: 
#
# Longitud media
#
# Ejemplos de llamada:
#
# longitudMedia(secuencias[1,])        # Primera secuencia
# longitudMedia(secuencias[1:7,])      # Secuencias de 1 a 7
# longitudMedia(secuencias[c(1,3,7),]) # Secuencias 1, 3 y 7
# longitudMedia(secuencias)            # Todas las secuencias

longitudMedia <- function(seqs) {
  return(round(mean(seqs$Longitud),2))
}

#
# Sexto Indicador
#
# Número de addBets totales con betCompleteds
#
# ------------------------------------------------------------------
#
# Nombre de la función: numAddbetsBetCompleted
#
# Descripción: 
#
# Devuelve el número total de addBets con betCompleted
#
# Variables de entrada: 
#
# contadores: matrix
#
# Variable de salida: 
#
# Número de addBets con betCompleteds


numAddbetsBetCompleted <- function(cont){
     numAddbetsBetComp <<- rowSums(cont)
}

#
# Séptimo Indicador
#
# Número de visitas a deportes del cluster
#
# ------------------------------------------------------------------
#
# Nombre de la función: visitasDeportesTotalesCluster
#
# Descripción: 
#
# Devuelve el número total de visitas a deportes del cluster
#
# Variables de entrada: 
#
# contadores: matrix
#
# Variable de salida: 
#
# Número de visitas a deportes del cluster


visitasDeportesTotalesCluster <- function(cont){
     numVisitasDeportesTotalesCluster <<- rowSums(cont)
}



# Constantes y funciones globales

# ------------------------------- Directorios
dirMatricesMetricas <- "C:/Users/Carlos/Documents/Máster/Proyecto/Codere/Datos/scripts_finales/OneDrive/Matrices métricas proyecto"
dirTrabajo <- "C:/Users/Carlos/Documents/Máster/Proyecto/Codere/Datos/scripts_finales/OneDrive"

# ------------------------------- Algunos pasos importantes
betCompleted <- 90
closeBet <- c(101)
addBet <- c(80:87)
ActivateDesStreaming <- 78

# ------------------------------- Números asignados a distancias
Jaccard <- 1
TfIdf <- 2
Levenshtein <- 3

nombreGrupos <- "clustersCodere"
nombreTablas <- "tablasSalida"
nombreSecuencias <- "secuencias"
nombreMatrizMetrica <- c("distancia")
nombre <- "grupo"


nombresDistancias <- c("Jac", "TfIdf", "Lev")
nombresDistanciasCompletos <- c("Jaccard", "TfIdf", "Levenshtein")
tamanosGrupos <- c(5,8,11)

nombresDistancias <- c("Jac")
nombresDistanciasCompletos <- c("Jac")
tamanosGrupos <- c(5,8,11)

numDistancias <- length(nombresDistancias)
numDimensiones <- length(tamanosGrupos)

# ---------------------------------------------
# evalua
#
# A partir de una cadena adecuada, devuelve el nombre de la
# estructura de datos que tiene por nombre esa cadena.
#
# Ejemplo: A partir de la cadena «clustersJac5» devuelve la
#          estructura de datos con ese nombre.
#
# 
# Variables de entrada:
#
# «x»: La cadena en cuestión.
#
# Variable de salida:
#
# Puntero a la estructura de datos.
#
# Ejemplo de uso:
#
# tabla <- creaResultados(nombres, matrizClicks, "Jac", 5)
# ---------------------------------------------

evalua <- function(x) {
  return(eval(parse(text=x)))}

# ---------------------------------------------
# memoriaObjetos
#
# Muestra lo que ocupan en memoria los «num» objetos 
# más grandes. La unidad de memoria se pasa como parámetro. 
# 
# Variables de entrada:
#
# «tamano»: Unidad de memoria, Puede tomar los siguientes 
#           valores: "kB", "MB", "GB"
# «num»: Número de objetos cuyo tamaño quiere consultarse.
#
# Variable de salida:
#
# Lista de objetos junto con sus tamaños en memoria.
#
# Ejemplo de uso:
#
# memoriaObjetos("GB", 10)  # Muestra en GB el tamaño en
# memoria de los 10 mayores objetos.
# ---------------------------------------------

memoriaObjetos <- function(tamano, num) {
  gc()
  print(paste0("Memoria utilizada: ", memory.size()))
  switch(tamano, 
         "bytes" = {unidad <- 1},
         "kB" = {unidad <-2^10},
         "MB" = {unidad <- 2^20},
         "GB" = {unidad <- 2^30})
  
  enMemoria <- (ls(envir = .GlobalEnv))
  
  print(round(head(sort(sapply(enMemoria,
                   function(x){
                     object.size(evalua(x))/unidad}), 
            decreasing = TRUE), num),2))
}


# ------------------------------- lista que contendrá las matrices de distancias
listaDistancias <- rep(list(-1), numDistancias)

# ------------------------------- lista de listas que contendrá los grupos

listaGrupos <- "list("
for (i in 1:numDistancias) {
  for(j in 1:numDimensiones) {
    listaGrupos<-(paste0(listaGrupos,nombreGrupos, nombresDistancias[i], 
                          tamanosGrupos[j]," = ",i, ", "))
  }
}
listaGrupos <- substr(listaGrupos, 1, nchar(listaGrupos)-2)
listaGrupos <- paste0(listaGrupos, ")")
listaGrupos <-evalua(listaGrupos)

# ------------------------------- lista de listas que contendrá 
#                                 las tablas de salida

listaTablas <- "list("
for (i in 1:numDistancias) {
  for(j in 1:numDimensiones) {
    listaTablas <- (paste0(listaTablas, nombreTablas, nombresDistancias[i], 
                         tamanosGrupos[j]," = ",i, ", "))
  }
}
listaTablas <- substr(listaTablas, 1, nchar(listaTablas)-2)
listaTablas <- paste0(listaTablas, ")")
listaTablas <-evalua(listaTablas)

# ------------------------------- lista de listas que contendrá 
#                                 el desglose de los grupos

listaSubGrupos <- "list("
for (i in 1:numDistancias) {
  for(j in tamanosGrupos) {
    for(k in 1:j) {
      listaSubGrupos<-(paste0(listaSubGrupos,nombreGrupos, nombresDistancias[i], 
                              j,"grupo",k, " = ",i, ", "))
      
    }
  }
}
listaSubGrupos <- substr(listaSubGrupos, 1, nchar(listaSubGrupos)-2)
listaSubGrupos <- paste0(listaSubGrupos, ")")
listaSubGrupos <-evalua(listaSubGrupos)
    
# Eventos que se retiran del algoritmo Tf-Idf. El 0 en la secuencia no es un evento
# y por tanto lo retiramos
evPocoSignif <- c(0)

columnasDeportes <- c("futbol", "baloncesto", "tenis", "voley", "beisbol", "balonmano",
                      "rugby", "futbolAmericano", "mejoraTuLinea", "galgos", "caballos", 
                      "artesMarciales", "boxeo", "dardos", "esports", "hockey", 
                      "loteria", "politica", "borrado", "deporteAnterior")
columnasDeportesVisitados <- c("futbolV", "baloncestoV", "tenisV", "voleyV", "beisbolV", "balonmanoV",
                      "rugbyV", "futbolAmericanoV", "mejoraTuLineaV", "galgosV", "caballosV", 
                      "artesMarcialesV", "boxeoV", "dardosV", "esportsV", "hockeyV", 
                      "loteriaV", "politicaV")


#
# Tercer indicador
#
# Deporte más apostado / betCompleted
#

# En la variable «contadoresApostados» se acumulan los cómputos
# de los deportes a los que se ha apostado
contadoresApostados <- matrix(vector(mode="numeric",
                            length = length(columnasDeportes)), 
                     ncol=length(columnasDeportes))
colnames(contadoresApostados) <- columnasDeportes

# En la variable «contadoresVisitados» se acumulan los cómputos
# de los deportes a los que se ha visitado
contadoresVisitados <- matrix(vector(mode="numeric",
                                     length = length(columnasDeportesVisitados)), 
                              ncol=length(columnasDeportesVisitados))
colnames(contadoresVisitados) <- columnasDeportesVisitados

# En la variable «contadoresTotales» se acumulan los cómputos
# totales de cada deporte de toda la muestra
contadoresTotales <- matrix(vector(mode="numeric",
                                   length = length(columnasDeportes)), 
                            ncol=length(columnasDeportes))
colnames(contadoresTotales) <- columnasDeportes

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

listaDeportesVisitados <- head(listaDeportes,-2)
names(listaDeportesVisitados) <- columnasDeportesVisitados

# Tabla de transferencia para una distancia y un número de grupos

tablaSalida <-
  list(tamanos = vector(mode = "numeric", length=0),
       medoides = vector(mode = "numeric", length=0),
       betCompleted1 = vector(mode = "numeric", length=0),
       betCompleted2 = vector(mode = "numeric", length=0),
       nApuestas = vector(mode = "numeric", length=0),
       nApostantes = vector(mode = "numeric", length=0),
       nNoApostantes = vector(mode = "numeric", length=0),
       porcApost = vector(mode = "numeric", length=0),
       porcLog = vector(mode = "numeric", length=0),
       longMedia = vector(mode = "numeric", length=0),
       ratioApuestasApostante = vector(mode = "numeric", length=0),
       ratioAddBetBetCompleted = vector(mode = "numeric", length=0),
       ratioCloseBetBetCompleted = vector(mode = "numeric", length=0),
       futbol = vector(mode = "numeric", length=0),
       baloncesto = vector(mode = "numeric", length=0),
       tenis = vector(mode = "numeric", length=0),
       voley = vector(mode = "numeric", length=0),
       beisbol = vector(mode = "numeric", length=0),
       balonmano = vector(mode = "numeric", length=0),
       rugby = vector(mode = "numeric", length=0),
       futbolAmericano = vector(mode = "numeric", length=0),
       mejoraTuLinea = vector(mode = "numeric", length=0),
       galgos = vector(mode = "numeric", length=0),
       caballos = vector(mode = "numeric", length=0),
       artesMarciales = vector(mode = "numeric", length=0),
       boxeo = vector(mode = "numeric", length=0),
       dardos = vector(mode = "numeric", length=0),
       esports = vector(mode = "numeric", length=0),
       hockey = vector(mode = "numeric", length=0),
       loteria = vector(mode = "numeric", length=0),
       politica = vector(mode = "numeric", length=0),
       
# Deportes visitados
       futbolV = vector(mode = "numeric", length=0),
       baloncestoV = vector(mode = "numeric", length=0),
       tenisV = vector(mode = "numeric", length=0),
       voleyV = vector(mode = "numeric", length=0),
       beisbolV = vector(mode = "numeric", length=0),
       balonmanoV = vector(mode = "numeric", length=0),
       rugbyV = vector(mode = "numeric", length=0),
       futbolAmericanoV = vector(mode = "numeric", length=0),
       mejoraTuLineaV = vector(mode = "numeric", length=0),
       galgosV = vector(mode = "numeric", length=0),
       caballosV = vector(mode = "numeric", length=0),
       artesMarcialesV = vector(mode = "numeric", length=0),
       boxeoV = vector(mode = "numeric", length=0),
       dardosV = vector(mode = "numeric", length=0),
       esportsV = vector(mode = "numeric", length=0),
       hockeyV = vector(mode = "numeric", length=0),
       loteriaV = vector(mode = "numeric", length=0),
       politicaV = vector(mode = "numeric", length=0))

# Tabla de transferencia para una distancia y un número de grupos fuente origen de BD

tablaSalidaBD <-
     list(name_clusterizacion = vector(mode = "numeric", length=0),
          distancia = vector(mode = "numeric", length=0),
          
          name_cluster = vector(mode = "numeric", length=0),
          medioide = vector(mode = "numeric", length=0),
          num_sesiones_cluster = vector(mode = "numeric", length=0),
          num_tickets_cerrados_cluster = vector(mode = "numeric", length=0),
          num_sesiones_apostantes_cluster = vector(mode = "numeric", length=0),
          num_sesiones_logadas_cluster = vector(mode = "numeric", length=0),
          num_sesiones_authenticated_cluster = vector(mode = "numeric", length=0),
          num_sesiones_streaming_cluster = vector(mode = "numeric", length=0),
          num_pasos_cluster = vector(mode = "numeric", length=0),
          
          
          num_apuestas_futbol_cluster = vector(mode = "numeric", length=0),
          num_visitas_futbol_cluster = vector(mode = "numeric", length=0),
          num_apuestas_baloncesto_cluster = vector(mode = "numeric", length=0),
          num_visitas_baloncesto_cluster = vector(mode = "numeric", length=0),
          num_apuestas_tenis_cluster = vector(mode = "numeric", length=0),
          num_visitas_tenis_cluster = vector(mode = "numeric", length=0),
          num_apuestas_voleibol_cluster = vector(mode = "numeric", length=0),
          num_visitas_voleibol_cluster = vector(mode = "numeric", length=0),
          num_apuestas_beisbol_cluster = vector(mode = "numeric", length=0),
          num_visitas_beisbol_cluster = vector(mode = "numeric", length=0),
          num_apuestas_balonmano_cluster = vector(mode = "numeric", length=0),
          num_visitas_balonmano_cluster = vector(mode = "numeric", length=0),
          num_apuestas_rugby_cluster = vector(mode = "numeric", length=0),
          num_visitas_rugby_cluster = vector(mode = "numeric", length=0),
          num_apuestas_futbol_americano_cluster = vector(mode = "numeric", length=0),
          num_visitas_futbol_americano_cluster = vector(mode = "numeric", length=0),
          num_apuestas_mejoraTuLinea_cluster = vector(mode = "numeric", length=0),
          num_visitas_mejoraTuLinea_cluster = vector(mode = "numeric", length=0),
          num_apuestas_galgos_cluster = vector(mode = "numeric", length=0),
          num_visitas_galgos_cluster = vector(mode = "numeric", length=0),
          num_apuestas_caballos_cluster = vector(mode = "numeric", length=0),
          num_visitas_caballos_cluster = vector(mode = "numeric", length=0),
          num_apuestas_artes_marciales_cluster = vector(mode = "numeric", length=0),
          num_visitas_artes_marciales_cluster = vector(mode = "numeric", length=0),
          num_apuestas_boxeo_cluster = vector(mode = "numeric", length=0),
          num_visitas_boxeo_cluster = vector(mode = "numeric", length=0),
          num_apuestas_dardos_cluster = vector(mode = "numeric", length=0),
          num_visitas_dardos_cluster = vector(mode = "numeric", length=0),
          num_apuestas_esports_cluster = vector(mode = "numeric", length=0),
          num_visitas_esports_cluster = vector(mode = "numeric", length=0),
          num_apuestas_hockey_cluster = vector(mode = "numeric", length=0),
          num_visitas_hockey_cluster = vector(mode = "numeric", length=0),
          num_apuestas_loteria_cluster = vector(mode = "numeric", length=0),
          num_visitas_loteria_cluster = vector(mode = "numeric", length=0),
          num_apuestas_politica_cluster = vector(mode = "numeric", length=0),
          num_visitas_politica_cluster = vector(mode = "numeric", length=0))

# ---------------------------------------------
# carga
#
# Función que carga del disco la estructura de datos cuyo
# nombre se le pasa como cadena. Si la estructura de datos
# ya está en memoria, la devuelve sin ir a disco.
# En el caso de que no se encuentre ni en memoria ni en 
# disco devuelve NULL.
#
# NOTA: El empleo de la función «readRDS» tiene la ventaja
#       de que se le puede dar a la estructura leída el
#       el nombre que se quiera.
# 
# Variables de entrada:
#
# «cadena»: Nombre de la estructura que se quiere recuperar.
# «directorio»: Directorio en el que se busca el fichero.
#
# Variable de salida:
#
# Puntero a la estructura de datos, si se encuentra dicha 
# estructura, NULL si no se encuentra.
#
# Ejemplo de uso:
#
# if(is.null(tabla <- cargaDeDisco("tablaCodificacionn", 
#                                  dirMatricesMetricas)))
# ---------------------------------------------

carga <- function(cadena, directorio) {
  
  directorioAnterior <- getwd()
  setwd(directorio)
  print(cadena)
  nom <- substr(cadena, 10, 12) 
  if(nom == "Jac" || nom == "TfI" || nom == "Lev") {
    print(paste0("Entro con:", nom))
      salida <- tryCatch({    
          switch(nom,
           "Jac" = {
             if(listaDist[1] == -1) {
               print(paste0("Cargando ", cadena, ".rds del disco"))
               readRDS(paste0(cadena, ".rds"))
             } else {
               evalua(cadena)
             }
           },      
           "TfI" = {
             if(listaDist[2] == -1) {
               print(paste0("Cargando ", cadena, ".rds del disco"))
               readRDS(paste0(cadena, ".rds"))
             } else {
               evalua(cadena)
             }
           },
           "Lev" = {
             if(listaDist[3] == -1) {
               print(paste0("Cargando ", cadena, ".rds del disco"))
               readRDS(paste0(cadena, ".rds"))
             } else {
               evalua(cadena)
             }
           })
      },
      error = function(mensaje) {
        print(mensaje)
        return(NULL)
      },
      warning = function(mensaje) {
        print(mensaje)
        return(NULL)
      },
      finally = {
        setwd(directorioAnterior)
      })
  } 
  else {
      salida <- tryCatch(
        {
          if(!exists(cadena)) {
            print(paste0("Cargando ", cadena, ".rds del disco"))
            readRDS(paste0(cadena, ".rds"))
          } else {
            evalua(cadena)
          }
        },
        error = function(mensaje) {
          print(mensaje)
          return(NULL)
        },
        warning = function(mensaje) {
          print(mensaje)
          return(NULL)
        },
        finally = {
          setwd(directorioAnterior)
        }
      )
  }
  return(salida)
}

cargaMatrizMetrica <- function(cadena, directorio) {
  
  directorioAnterior <- getwd()
  setwd(directorio)
  print(cadena)
  salida <- tryCatch(
    {
      if(!exists(cadena)) {
        print(paste0("Cargando ", cadena, ".rds del disco"))
        readRDS(paste0(cadena, ".rds"))
      } else {
        evalua(cadena)
      }
    },
    error = function(mensaje) {
      print(mensaje)
      return(NULL)
    },
    warning = function(mensaje) {
      print(mensaje)
      return(NULL)
    },
    finally = {
      setwd(directorioAnterior)
    }
  )
  return(salida)
}
  
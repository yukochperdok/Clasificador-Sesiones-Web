

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
# creaResultados
#
# Genera una tabla de indicadores para una distancia y un
# determinado agrupamiento.
#
# Ejemplo: Crea una tabla para 5 grupos sobre la distancia Jaccard.
#
# NOTA: Los indicadores más complejos deben estar previamente
#       calculados.
# 
# Variables de entrada:
#
# «nombres»: Es una lista nominal que contiene los nombres de los 
#            indicadores que van a aparecer en las columnas de la
#            tabla.
# «matriz»: Tabla de clicks.
# «dist»: Cadena que se refiere a la distancia empleada para los
#         indicadores. Puede ser «Jac», «TfIdf» o «Levenshtein».
# «num»: Entero que se corresponde con alguna de las agrupaciones
#        previamente calculadas.
#
# Variable de salida:
#
# Una tabla con todos los indicadores calculados para la distancia
# y el número de grupos en cuestión.
#
# Ejemplo de uso:
#
# variable <- evalua(paste0("clustersCodere", "Jac", 5))
# 
# «variable», tras la asignación, es la estructura de datos cuyo
# nombre es clustersCodereJac5.
# ---------------------------------------------

                 
creaResultadosBD <- function (nombres, matriz, dist, num) {
  
     
  
    # Vectores de longitud cero con los nombres de las columnas del dataframe
    name_clusterizacion <- c()
    distancia <- c()
    name_cluster <- c()
    #tamanos
    num_sesiones_cluster <- c()
    #medoides
    medioide <- c()
    #betCompleted1 <- c()
    #ratio_tickets_cerrados_sesiones_cluster <- c()
    #betCompleted2 <- c()
    #ratio_tickets_cerrados_sesiones_apostantes_cluster <- c()
    #nApuestas <- c()
    num_tickets_cerrados_cluster <- c()
    #nApostantes <- c()
    num_sesiones_apostantes_cluster <- c()
    #porcApost <- c()
    #ratio_sesiones_apostantes_cluster <- c()
    #porcLog <- c()
    num_sesiones_logadas_cluster <- c()
    #ratio_sesiones_logadas_cluster <- c()
    #longMedia <- c()
    num_pasos_cluster <- c()
    #ratioAddBetBetCompleted <- c()
    #ratio_apuestas_tickets_cerrados_cluster <- c() 
    
    num_sesiones_authenticated_cluster <- c()
    #ratio_sesiones_authenticated_cluster <- c()
    
    num_sesiones_streaming_cluster <-c()
    
    #num_apuestas_cluster <- c()
    #num_deportes_visitados_cluster <- c()
    #num_sesiones_logadas_cluster <- c()
    
    #futbol <- c()
    num_apuestas_futbol_cluster <- c()
    #baloncesto <- c()
    num_apuestas_baloncesto_cluster <- c()
    #tenis <- c()
    num_apuestas_tenis_cluster <- c()
    #voley <- c()
    num_apuestas_voleibol_cluster <- c()
    #beisbol <- c()
    num_apuestas_beisbol_cluster <- c()
    #balonmano <- c()
    num_apuestas_balonmano_cluster <- c()
    #rugby <- c()
    num_apuestas_rugby_cluster <- c()
    #futbolAmericano <- c()
    num_apuestas_futbol_americano_cluster <- c()
    #mejoraTuLinea <- c()
    num_apuestas_mejoraTuLinea_cluster <- c()
    #galgos <- c()
    num_apuestas_galgos_cluster <- c()
    #caballos <- c()
    num_apuestas_caballos_cluster <- c()
    #artesMarciales <- c()
    num_apuestas_artes_marciales_cluster <- c()
    #boxeo <- c()
    num_apuestas_boxeo_cluster <- c()
    #dardos <- c()
    num_apuestas_dardos_cluster <- c()
    #esports <- c()
    num_apuestas_esports_cluster <- c()
    #hockey <- c()
    num_apuestas_hockey_cluster <- c()
    #loteria <- c()
    num_apuestas_loteria_cluster <- c()
    #politica <- c()
    num_apuestas_politica_cluster <- c()
    
    num_apuestas_futbol_totales <- c()
    num_apuestas_baloncesto_totales <- c()
    num_apuestas_tenis_totales <- c()
    num_apuestas_voleibol_totales <- c()
    num_apuestas_beisbol_totales <- c()
    num_apuestas_balonmano_totales <- c()
    num_apuestas_rugby_totales <- c()
    num_apuestas_futbol_americano_totales <- c()
    num_apuestas_mejoraTuLinea_totales <- c()
    num_apuestas_galgos_totales <- c()
    num_apuestas_caballos_totales <- c()
    num_apuestas_artes_marciales_totales <- c()
    num_apuestas_boxeo_totales <- c()
    num_apuestas_dardos_totales <- c()
    num_apuestas_esports_totales <- c()
    num_apuestas_hockey_totales <- c()
    num_apuestas_loteria_totales <- c()
    num_apuestas_politica_totales <- c()
    
    num_visitas_futbol_cluster <- c()
    num_visitas_baloncesto_cluster <- c()
    num_visitas_tenis_cluster <- c()
    num_visitas_voleibol_cluster <- c()
    num_visitas_beisbol_cluster <- c()
    num_visitas_balonmano_cluster <- c()
    num_visitas_rugby_cluster <- c()
    num_visitas_futbol_americano_cluster <- c()
    num_visitas_mejoraTuLinea_cluster <- c()
    num_visitas_galgos_cluster <- c()
    num_visitas_caballos_cluster <- c()
    num_visitas_artes_marciales_cluster <- c()
    num_visitas_boxeo_cluster <- c()
    num_visitas_dardos_cluster <- c()
    num_visitas_esports_cluster <- c()
    num_visitas_hockey_cluster <- c()
    num_visitas_loteria_cluster <- c()
    num_visitas_politica_cluster <- c()
    
  
    
    # Iteramos para cada grupo de la agrupación
    invisible(sapply(1:num, function(grupo) {

     # Creamos el nombre de la agrupación, ejemplo: clustersCodereJac5
     cluster <- evalua(paste0("listaGrupos$clustersCodere", dist, num))
     nameClusterizacion <- paste0("clustersCodere", dist, num)
         
      # Creamos el nombre de un grupo, ejemplo: grupoJac5grupo4
      agrupamiento <- evalua(paste0("listaSubGrupos$clustersCodere", 
                                       dist, num, "grupo", grupo)) 
      nameCluster <- paste0("clustersCodere", 
                             dist, num, "grupo", grupo)
      
      # Calculamos los contadores para el agrupamiento en cuestión: deportes apostados
      reinicioContadoresApostados()
      invisible(acumuladorDeportesApostados(agrupamiento, listaDeportes))
      
      # Calculamos los contadores para el agrupamiento en cuestión: visitas
      reinicioContadoresVisitados()
      invisible(acumuladorDeportesVisitados(agrupamiento[["Secuencia"]], listaDeportesVisitados))
      
      # Calculamos los contadoresTotales para todas las secuencias sin clusterizar
      reinicioContadoresTotales()
      invisible(acumuladorDeportesTotales(secuencias, listaDeportes))
      
      # Calculamos el número total de addBets con betCompleted del Cluster
      addBetsTotalesCluster <- numAddbetsBetCompleted(contadoresApostados)
      
      # Calculamos el número total de visitas a deportes del Cluster
      numVisitasDeportesTotalesCluster <- visitasDeportesTotalesCluster(contadoresVisitados)
      
      # Calculamos el número de fila que corresponde con el medioide y su correspondiente
      # secuencia convertida en una cadena de caracteres separada por comas.
      rowMedioide <- cluster$medoids[grupo]
      secuenciasDf <- as.data.frame(secuencias)
      secMedioide <- paste(as.character(unlist(secuenciasDf[rowMedioide,]$Secuencia)), collapse = ",")

    # Iteramos según las columnas
      invisible(sapply(names(nombres), function(columna) {

          switch(columna, 
                 "name_clusterizacion" = {
                      name_clusterizacion <<- c(name_clusterizacion, nameClusterizacion)},
                 "distancia" = {
                      distancia <<- c(distancia, dist)},
                 "name_cluster" = {
                      name_cluster <<- c(name_cluster, nameCluster)},
                 #"num_sesiones_cluster" = {
                 #     num_sesiones_cluster <<- c(num_sesiones_cluster, 
                 #                                cogeCluster(matriz, paste0(dist, num), grupo)[[1]])},
                 "num_sesiones_cluster" = {
                      num_sesiones_cluster <<- c(num_sesiones_cluster, 
                                                 nrow(agrupamiento))},
                 "medioide" = {
                      medioide <<- c(medioide, secMedioide)}, 
                 "num_tickets_cerrados_cluster" = {
                      num_tickets_cerrados_cluster <<- c(num_tickets_cerrados_cluster, 
                                                         numApuestas(agrupamiento))},
                 "num_sesiones_apostantes_cluster" = {
                      num_sesiones_apostantes_cluster <<- c(num_sesiones_apostantes_cluster, 
                                                            numApostantes(agrupamiento))},
                 "num_sesiones_logadas_cluster" = {
                      num_sesiones_logadas_cluster <<- c(num_sesiones_logadas_cluster, 
                                                            numLogados(agrupamiento))},
                 "num_sesiones_authenticated_cluster" = {
                      num_sesiones_authenticated_cluster <<- c(num_sesiones_authenticated_cluster, 
                                                              numAuthenticateds(agrupamiento))},
                 "num_sesiones_streaming_cluster" = {
                      num_sesiones_streaming_cluster <<- c(num_sesiones_streaming_cluster, 
                                                               numStreamings(agrupamiento))},
                 "num_pasos_cluster" = {
                      num_pasos_cluster <<- c(num_pasos_cluster,
                                              longitudMedia(agrupamiento))},
                 
                 "num_apuestas_futbol_cluster" = {
                      num_apuestas_futbol_cluster <<- 
                           c(num_apuestas_futbol_cluster, contadoresApostados[1, "futbol"][[1]])},
                 "num_apuestas_baloncesto_cluster" = {
                      num_apuestas_baloncesto_cluster <<- 
                           c(num_apuestas_baloncesto_cluster, contadoresApostados[1, "baloncesto"][[1]])},
                 "num_apuestas_tenis_cluster" = {
                      num_apuestas_tenis_cluster <<- 
                           c(num_apuestas_tenis_cluster, contadoresApostados[1, "tenis"][[1]])},
                 "num_apuestas_voleibol_cluster" = {
                      num_apuestas_voleibol_cluster <<- 
                           c(num_apuestas_voleibol_cluster, contadoresApostados[1, "voley"][[1]])},
                 "num_apuestas_beisbol_cluster" = {
                      num_apuestas_beisbol_cluster <<- 
                           c(num_apuestas_beisbol_cluster, contadoresApostados[1, "beisbol"][[1]])},
                 "num_apuestas_balonmano_cluster" = {
                      num_apuestas_balonmano_cluster <<- 
                           c(num_apuestas_balonmano_cluster, contadoresApostados[1, "balonmano"][[1]])},
                 "num_apuestas_rugby_cluster" = {
                      num_apuestas_rugby_cluster <<- 
                           c(num_apuestas_rugby_cluster, contadoresApostados[1, "rugby"][[1]])},
                 "num_apuestas_futbol_americano_cluster" = {
                      num_apuestas_futbol_americano_cluster <<- 
                           c(num_apuestas_futbol_americano_cluster, contadoresApostados[1, "futbolAmericano"][[1]])},
                 "num_apuestas_mejoraTuLinea_cluster" = {
                      num_apuestas_mejoraTuLinea_cluster <<- 
                           c(num_apuestas_mejoraTuLinea_cluster, contadoresApostados[1, "mejoraTuLinea"][[1]])},
                 "num_apuestas_galgos_cluster" = {
                      num_apuestas_galgos_cluster <<- 
                           c(num_apuestas_galgos_cluster, contadoresApostados[1, "galgos"][[1]])},
                 "num_apuestas_caballos_cluster" = {
                      num_apuestas_caballos_cluster <<- 
                           c(num_apuestas_caballos_cluster, contadoresApostados[1, "caballos"][[1]])},
                 "num_apuestas_artes_marciales_cluster" = {
                      num_apuestas_artes_marciales_cluster <<- 
                           c(num_apuestas_artes_marciales_cluster, contadoresApostados[1, "artesMarciales"][[1]])},
                 "num_apuestas_boxeo_cluster" = {
                      num_apuestas_boxeo_cluster <<- 
                           c(num_apuestas_boxeo_cluster, contadoresApostados[1, "boxeo"][[1]])},
                 "num_apuestas_dardos_cluster" = {
                      num_apuestas_dardos_cluster <<- 
                           c(num_apuestas_dardos_cluster, contadoresApostados[1, "dardos"][[1]])},
                 "num_apuestas_esports_cluster" = {
                      num_apuestas_esports_cluster <<- 
                           c(num_apuestas_esports_cluster, contadoresApostados[1, "esports"][[1]])},
                 "num_apuestas_hockey_cluster" = {
                      num_apuestas_hockey_cluster <<- 
                           c(num_apuestas_hockey_cluster, contadoresApostados[1, "hockey"][[1]])},
                 "num_apuestas_loteria_cluster" = {
                      num_apuestas_loteria_cluster <<- 
                           c(num_apuestas_loteria_cluster, contadoresApostados[1, "loteria"][[1]])},
                 "num_apuestas_politica_cluster" = {
                      num_apuestas_politica_cluster <<- 
                           c(num_apuestas_politica_cluster, contadoresApostados[1, "politica"][[1]])},
                 
                 "num_apuestas_futbol_totales" = {
                      num_apuestas_futbol_totales <<- 
                           c(num_apuestas_futbol_totales, contadoresTotales[1, "futbol"][[1]])},
                 "num_apuestas_baloncesto_totales" = {
                      num_apuestas_baloncesto_totales <<- 
                           c(num_apuestas_baloncesto_totales, contadoresTotales[1, "baloncesto"][[1]])},
                 "num_apuestas_tenis_totales" = {
                      num_apuestas_tenis_totales <<- 
                           c(num_apuestas_tenis_totales, contadoresTotales[1, "tenis"][[1]])},
                 "num_apuestas_voleibol_totales" = {
                      num_apuestas_voleibol_totales <<- 
                           c(num_apuestas_voleibol_totales, contadoresTotales[1, "voley"][[1]])},
                 "num_apuestas_beisbol_totales" = {
                      num_apuestas_beisbol_totales <<- 
                           c(num_apuestas_beisbol_totales, contadoresTotales[1, "beisbol"][[1]])},
                 "num_apuestas_balonmano_totales" = {
                      num_apuestas_balonmano_totales <<- 
                           c(num_apuestas_balonmano_totales, contadoresTotales[1, "balonmano"][[1]])},
                 "num_apuestas_rugby_totales" = {
                      num_apuestas_rugby_totales <<- 
                           c(num_apuestas_rugby_totales, contadoresTotales[1, "rugby"][[1]])},
                 "num_apuestas_futbol_americano_totales" = {
                      num_apuestas_futbol_americano_totales <<- 
                           c(num_apuestas_futbol_americano_totales, contadoresTotales[1, "futbolAmericano"][[1]])},
                 "num_apuestas_mejoraTuLinea_totales" = {
                      num_apuestas_mejoraTuLinea_totales <<- 
                           c(num_apuestas_mejoraTuLinea_totales, contadoresTotales[1, "mejoraTuLinea"][[1]])},
                 "num_apuestas_galgos_totales" = {
                      num_apuestas_galgos_totales <<- 
                           c(num_apuestas_galgos_totales, contadoresTotales[1, "galgos"][[1]])},
                 "num_apuestas_caballos_totales" = {
                      num_apuestas_caballos_totales <<- 
                           c(num_apuestas_caballos_totales, contadoresTotales[1, "caballos"][[1]])},
                 "num_apuestas_artes_marciales_totales" = {
                      num_apuestas_artes_marciales_totales <<- 
                           c(num_apuestas_artes_marciales_totales, contadoresTotales[1, "artesMarciales"][[1]])},
                 "num_apuestas_boxeo_totales" = {
                      num_apuestas_boxeo_totales <<- 
                           c(num_apuestas_boxeo_totales, contadoresTotales[1, "boxeo"][[1]])},
                 "num_apuestas_dardos_totales" = {
                      num_apuestas_dardos_totales <<- 
                           c(num_apuestas_dardos_totales, contadoresTotales[1, "dardos"][[1]])},
                 "num_apuestas_esports_totales" = {
                      num_apuestas_esports_totales <<- 
                           c(num_apuestas_esports_totales, contadoresTotales[1, "esports"][[1]])},
                 "num_apuestas_hockey_totales" = {
                      num_apuestas_hockey_totales <<- 
                           c(num_apuestas_hockey_totales, contadoresTotales[1, "hockey"][[1]])},
                 "num_apuestas_loteria_totales" = {
                      num_apuestas_loteria_totales <<- 
                           c(num_apuestas_loteria_totales, contadoresTotales[1, "loteria"][[1]])},
                 "num_apuestas_politica_totales" = {
                      num_apuestas_politica_totales <<- 
                           c(num_apuestas_politica_totales, contadoresTotales[1, "politica"][[1]])},
                 
                 
                 "num_visitas_futbol_cluster" = {
                      num_visitas_futbol_cluster <<- 
                           c(num_visitas_futbol_cluster, contadoresVisitados[1, "futbolV"][[1]])},
                 "num_visitas_baloncesto_cluster" = {
                      num_visitas_baloncesto_cluster <<- 
                           c(num_visitas_baloncesto_cluster, contadoresVisitados[1, "baloncestoV"][[1]])},
                 "num_visitas_tenis_cluster" = {
                      num_visitas_tenis_cluster <<- 
                           c(num_visitas_tenis_cluster, contadoresVisitados[1, "tenisV"][[1]])},
                 "num_visitas_voleibol_cluster" = {
                      num_visitas_voleibol_cluster <<- 
                           c(num_visitas_voleibol_cluster, contadoresVisitados[1, "voleyV"][[1]])},
                 "num_visitas_beisbol_cluster" = {
                      num_visitas_beisbol_cluster <<- 
                           c(num_visitas_beisbol_cluster, contadoresVisitados[1, "beisbolV"][[1]])},
                 "num_visitas_balonmano_cluster" = {
                      num_visitas_balonmano_cluster <<- 
                           c(num_visitas_balonmano_cluster, contadoresVisitados[1, "balonmanoV"][[1]])},
                 "num_visitas_rugby_cluster" = {
                      num_visitas_rugby_cluster <<- 
                           c(num_visitas_rugby_cluster, contadoresVisitados[1, "rugbyV"][[1]])},
                 "num_visitas_futbol_americano_cluster" = {
                      num_visitas_futbol_americano_cluster <<- 
                           c(num_visitas_futbol_americano_cluster, contadoresVisitados[1, "futbolAmericanoV"][[1]])},
                 "num_visitas_mejoraTuLinea_cluster" = {
                      num_visitas_mejoraTuLinea_cluster <<- 
                           c(num_visitas_mejoraTuLinea_cluster, contadoresVisitados[1, "mejoraTuLineaV"][[1]])},
                 "num_visitas_galgos_cluster" = {
                      num_visitas_galgos_cluster <<- 
                           c(num_visitas_galgos_cluster, contadoresVisitados[1, "galgosV"][[1]])},
                 "num_visitas_caballos_cluster" = {
                      num_visitas_caballos_cluster <<- 
                           c(num_visitas_caballos_cluster, contadoresVisitados[1, "caballosV"][[1]])},
                 "num_visitas_artes_marciales_cluster" = {
                      num_visitas_artes_marciales_cluster <<- 
                           c(num_visitas_artes_marciales_cluster, contadoresVisitados[1, "artesMarcialesV"][[1]])},
                 "num_visitas_boxeo_cluster" = {
                      num_visitas_boxeo_cluster <<- 
                           c(num_visitas_boxeo_cluster, contadoresVisitados[1, "boxeoV"][[1]])},
                 "num_visitas_dardos_cluster" = {
                      num_visitas_dardos_cluster <<- 
                           c(num_visitas_dardos_cluster, contadoresVisitados[1, "dardosV"][[1]])},
                 "num_visitas_esports_cluster" = {
                      num_visitas_esports_cluster <<- 
                           c(num_visitas_esports_cluster, contadoresVisitados[1, "esportsV"][[1]])},
                 "num_visitas_hockey_cluster" = {
                      num_visitas_hockey_cluster <<- 
                           c(num_visitas_hockey_cluster, contadoresVisitados[1, "hockeyV"][[1]])},
                 "num_visitas_loteria_cluster" = {
                      num_visitas_loteria_cluster <<- 
                           c(num_visitas_loteria_cluster, contadoresVisitados[1, "loteriaV"][[1]])},
                 "num_visitas_politica_cluster" = {
                      num_visitas_politica_cluster <<- 
                           c(num_visitas_politica_cluster, contadoresVisitados[1, "politicaV"][[1]])}
                 
             
          ) # switch

      })) # invisible

  })) # invisible

    # Se crea el dataframe
    df <- as.data.frame(
         cbind(name_clusterizacion, distancia, 
               
               name_cluster, medioide, 
               num_sesiones_cluster, num_tickets_cerrados_cluster,
               num_sesiones_apostantes_cluster, num_sesiones_logadas_cluster,
               num_sesiones_authenticated_cluster, num_sesiones_streaming_cluster, 
               num_pasos_cluster,
               
               num_apuestas_futbol_cluster, num_visitas_futbol_cluster, 
               num_apuestas_baloncesto_cluster, num_visitas_baloncesto_cluster, 
               num_apuestas_tenis_cluster, num_visitas_tenis_cluster, 
               num_apuestas_voleibol_cluster, num_visitas_voleibol_cluster,
               num_apuestas_beisbol_cluster, num_visitas_beisbol_cluster,
               num_apuestas_balonmano_cluster, num_visitas_balonmano_cluster,
               num_apuestas_rugby_cluster, num_visitas_rugby_cluster,
               num_apuestas_futbol_americano_cluster, num_visitas_futbol_americano_cluster,
               num_apuestas_mejoraTuLinea_cluster, num_visitas_mejoraTuLinea_cluster,
               num_apuestas_galgos_cluster, num_visitas_galgos_cluster,
               num_apuestas_caballos_cluster, num_visitas_caballos_cluster,
               num_apuestas_artes_marciales_cluster, num_visitas_artes_marciales_cluster,
               num_apuestas_boxeo_cluster, num_visitas_boxeo_cluster,
               num_apuestas_dardos_cluster, num_visitas_dardos_cluster,
               num_apuestas_esports_cluster, num_visitas_esports_cluster,
               num_apuestas_hockey_cluster, num_visitas_hockey_cluster,
               num_apuestas_loteria_cluster, num_visitas_loteria_cluster,
               num_apuestas_politica_cluster, num_visitas_politica_cluster)
               )
               
    
    colnames(df) <- names(nombres)
    return(df)
}


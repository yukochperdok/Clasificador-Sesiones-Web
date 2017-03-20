
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
# ---------------------------------------------

                 
creaResultados <- function (nombres, matriz, dist, num) {
  
    # Vectores de longitud cero con los nombres de las columnas del dataframe
    tamanos <- c()
    medoides <- c()
    betCompleted1 <- c()
    betCompleted2 <- c()
    nApuestas <- c()
    nApostantes <- c()
    nNoApostantes <- c()
    porcApost <- c()
    porcLog <- c()
    longMedia <- c()
    ratioApuestasApostante <- c()
    ratioAddBetBetCompleted <- c()
    ratioCloseBetBetCompleted <- c()
    futbol <- c()
    baloncesto <- c()
    tenis <- c()
    voley <- c()
    beisbol <- c()
    balonmano <- c()
    rugby <- c()
    futbolAmericano <- c()
    mejoraTuLinea <- c()
    galgos <- c()
    caballos <- c()
    artesMarciales <- c()
    boxeo <- c()
    dardos <- c()
    esports <- c()
    hockey <- c()
    loteria <- c()
    politica <- c()
    
# Deportes visitados
    futbolV <- c()
    baloncestoV <- c()
    tenisV <- c()
    voleyV <- c()
    beisbolV <- c()
    balonmanoV <- c()
    rugbyV <- c()
    futbolAmericanoV <- c()
    mejoraTuLineaV <- c()
    galgosV <- c()
    caballosV <- c()
    artesMarcialesV <- c()
    boxeoV <- c()
    dardosV <- c()
    esportsV <- c()
    hockeyV <- c()
    loteriaV <- c()
    politicaV <- c()
  
    # Iteramos para cada grupo de la agrupación
    invisible(sapply(1:num, function(grupo) {

      # Creamos el nombre de la agrupación, ejemplo: clustersCodereJac5
      cluster <- evalua(paste0("listaGrupos$clustersCodere", dist, num))
      
      # Creamos el nombre de un grupo, ejemplo: grupoJac5grupo4
      agrupamiento <- evalua(paste0("listaSubGrupos$clustersCodere", 
                                    dist, num, "grupo", grupo))    
      
      # Calculamos los contadores para el agrupamiento en cuestión
      reinicioContadoresApostados()
      invisible(acumuladorDeportesApostados(agrupamiento, listaDeportes))
      reinicioContadoresVisitados()
      invisible(acumuladorDeportesVisitados(agrupamiento[["Secuencia"]], listaDeportesVisitados))
      
    # Iteramos según las columnas
      invisible(sapply(names(nombres), function(columna) {
          # print(paste0("columna:",columna))
          switch(columna, 
             "tamanos" = {
               tamanos <<- c(tamanos, 
                             cogeCluster(matriz, paste0(dist, num), grupo)[[1]])},
             "medoides" = {
               medoides <<- c(medoides, cluster$medoids[grupo])}, 
             "betCompleted1" = {
              betCompleted1 <<- c(betCompleted1, 
                                  mediaSecuenciasBetCompleted(agrupamiento))},
             "betCompleted2" = {
               betCompleted2 <<- c(betCompleted2, 
                                   mediasBetCompleted(agrupamiento))},
             "nApuestas" = {
               nApuestas <<- c(nApuestas, 
                               numApuestas(agrupamiento))},
             "nApostantes" = {
               nApostantes <<- c(nApostantes, 
                               numApostantes(agrupamiento))},
             "nNoApostantes" = {
               nNoApostantes <<- c(nNoApostantes, 
                                 numNOApostantes(agrupamiento))},
             "porcApost" = {
               porcApost <<- c(porcApost, 
                               porcentajeApostantes(agrupamiento))},
             "porcLog" = {
               porcLog <<- c(porcLog, 
                               porcentajeLogados(agrupamiento))},
             "longMedia" = {
               longMedia <<- c(longMedia,
                               longitudMedia(agrupamiento))},
             "ratioApuestasApostante" = {
               ratioApuestasApostante <<- c(ratioApuestasApostante, round(
                                            numApuestas(agrupamiento)/
                                              numApostantes(agrupamiento), 2))},
             "ratioAddBetBetCompleted" = {
               ratioAddBetBetCompleted <<- 
                 c(ratioAddBetBetCompleted,
                   ratioSecuenciasPrimero_BetCompleted(agrupamiento, addBet))},
             "ratioCloseBetBetCompleted" = {
               ratioCloseBetBetCompleted <<- 
                 c(ratioCloseBetBetCompleted,
                   ratioSecuenciasPrimero_BetCompleted(agrupamiento, closeBet))},
             "futbol" = {
               futbol <<- c(futbol, contadoresApostados[1, "futbol"][[1]])},
             "baloncesto" = {
               baloncesto <<- c(baloncesto, contadoresApostados[1, "baloncesto"][[1]])},
             "tenis" = {
               tenis <<- c(tenis, contadoresApostados[1, "tenis"][[1]])},
             "voley" = {
               voley <<- c(voley, contadoresApostados[1, "voley"][[1]])},
             "beisbol" = {
               beisbol <<- c(beisbol, contadoresApostados[1, "beisbol"][[1]])},
             "balonmano" = {
               balonmano <<- c(balonmano, contadoresApostados[1, "balonmano"][[1]])},
             "rugby" = {
               rugby <<- c(rugby, contadoresApostados[1, "rugby"][[1]])},
             "futbolAmericano" = {
               futbolAmericano <<- c(futbolAmericano, contadoresApostados[1, "futbolAmericano"][[1]])},
             "mejoraTuLinea" = {
               mejoraTuLinea <<- c(mejoraTuLinea, contadoresApostados[1, "mejoraTuLinea"][[1]])},
             "galgos" = {
               galgos <<- c(galgos, contadoresApostados[1, "galgos"][[1]])},
             "caballos" = {
               caballos <<- c(caballos, contadoresApostados[1, "caballos"][[1]])},
             "artesMarciales" = {
               artesMarciales <<- c(artesMarciales, contadoresApostados[1, "artesMarciales"][[1]])},
             "boxeo" = {
               boxeo <<- c(boxeo, contadoresApostados[1, "boxeo"][[1]])},
             "dardos" = {
               dardos <<- c(dardos, contadoresApostados[1, "dardos"][[1]])},
             "esports" = {
               esports <<- c(esports, contadoresApostados[1, "esports"][[1]])},
             "hockey" = {
               hockey <<- c(hockey, contadoresApostados[1, "hockey"][[1]])},
             "loteria" = {
               loteria <<- c(loteria, contadoresApostados[1, "loteria"][[1]])},
             "politica" = {
               politica <<- c(politica, contadoresApostados[1, "politica"][[1]])},
          
             # Deportes visitados
             
             "futbolV" = {
               futbolV <<- c(futbolV, contadoresVisitados[1, "futbolV"][[1]])},
             "baloncestoV" = {
               baloncestoV <<- c(baloncestoV, contadoresVisitados[1, "baloncestoV"][[1]])},
             "tenisV" = {
               tenisV <<- c(tenisV, contadoresVisitados[1, "tenisV"][[1]])},
             "voleyV" = {
               voleyV <<- c(voleyV, contadoresVisitados[1, "voleyV"][[1]])},
             "beisbolV" = {
               beisbolV <<- c(beisbolV, contadoresVisitados[1, "beisbolV"][[1]])},
             "balonmanoV" = {
               balonmanoV <<- c(balonmanoV, contadoresVisitados[1, "balonmanoV"][[1]])},
             "rugbyV" = {
               rugbyV <<- c(rugbyV, contadoresVisitados[1, "rugbyV"][[1]])},
             "futbolAmericanoV" = {
               futbolAmericanoV <<- c(futbolAmericanoV, contadoresVisitados[1, "futbolAmericanoV"][[1]])},
             "mejoraTuLineaV" = {
               mejoraTuLineaV <<- c(mejoraTuLineaV, contadoresVisitados[1, "mejoraTuLineaV"][[1]])},
             "galgosV" = {
               galgosV <<- c(galgosV, contadoresVisitados[1, "galgosV"][[1]])},
             "caballosV" = {
               caballosV <<- c(caballosV, contadoresVisitados[1, "caballosV"][[1]])},
             "artesMarcialesV" = {
               artesMarcialesV <<- c(artesMarcialesV, contadoresVisitados[1, "artesMarcialesV"][[1]])},
             "boxeoV" = {
               boxeoV <<- c(boxeoV, contadoresVisitados[1, "boxeoV"][[1]])},
             "dardosV" = {
               dardosV <<- c(dardosV, contadoresVisitados[1, "dardosV"][[1]])},
             "esportsV" = {
               esportsV <<- c(esportsV, contadoresVisitados[1, "esportsV"][[1]])},
             "hockeyV" = {
               hockeyV <<- c(hockeyV, contadoresVisitados[1, "hockeyV"][[1]])},
             "loteriaV" = {
               loteriaV <<- c(loteriaV, contadoresVisitados[1, "loteriaV"][[1]])},
             "politicaV" = {
               politicaV <<- c(politicaV, contadoresVisitados[1, "politicaV"][[1]])}
          ) # switch

      })) # invisible

  })) # invisible

  # Se crea el dataframe
  df <- as.data.frame(
    cbind(tamanos, medoides, betCompleted1, betCompleted2, 
          nApuestas, nApostantes, nNoApostantes, porcApost, porcLog, 
          longMedia, ratioApuestasApostante, ratioAddBetBetCompleted,
          ratioCloseBetBetCompleted, 
          
          # Deportes apostados
          futbol, baloncesto, tenis, voley, beisbol, balonmano, rugby, 
          futbolAmericano, mejoraTuLinea, galgos, caballos, artesMarciales, 
          boxeo, dardos, esports, hockey, loteria, politica,
          
          # Deportes vistos
          futbolV, baloncestoV, tenisV, voleyV, beisbolV, balonmanoV, rugbyV, 
          futbolAmericanoV,mejoraTuLineaV, galgosV, caballosV, artesMarcialesV, 
          boxeoV, dardosV,esportsV, hockeyV, loteriaV, politicaV
          ))
  colnames(df) <- names(nombres)
  return(df)  
}


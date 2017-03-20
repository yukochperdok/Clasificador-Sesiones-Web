
#
# Versión que se conecta a la BD de Azure en forma de tabla, no lee los blobs
#
#

# rm(list=ls())
# setwd("C:/Users/Alvaro/OneDrive/Proyecto MBIT/Proyecto - Codere/Datos/Datos_Codere")
# ficheros <- list.files()

is.installed <- function(paquete) is.element (
  paquete, installed.packages())

if(!is.installed("ggplot2"))
  install.packages("ggplot2")
if(!is.installed("gridExtra"))
  install.packages("gridExtra")
if(!is.installed("data.table"))
  install.packages("data.table")
if(!is.installed("proxy"))
  install.packages("proxy")
if(!is.installed("tm"))
  install.packages("tm")
if(!is.installed("slam"))
  install.packages("slam")
if(!is.installed("NbClust"))
  install.packages("NbClust")
if(!is.installed("stringdist"))
  install.packages("stringdist")
if(!is.installed("cluster"))
  install.packages("cluster")
if(!is.installed("fpc"))
  install.packages("fpc")
if(!is.installed("plyr"))
  install.packages("plyr")
if(!is.installed("OIsurv"))
  install.packages("OIsurv")
if(!is.installed("RODBC"))
  install.packages("RODBC")

require(ggplot2)
require(gridExtra)
require(data.table)
require(proxy)   # Función «dist»
require(tm)      # Funciones de minería de textos
require(slam)    # Función «crossprod_simple_triplet_matrix»
require(NbClust)
require(stringdist) # Función seq_distmatrix
require(cluster)
require(fpc)
require(plyr)    # Función «plyr»
require(OIsurv)  # Funciones de análisis de supervivencia
require(RODBC) 

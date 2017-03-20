# ------------------------------------------------------------------
#
# Nombre de la función: creaMatrizNavegacion
#
# Descripción:
# 
# Crea un data.frame cuyas filas son secuencias de navegación y cuyas columnas
# son los pasos de la secuencia
#
# Variables de entrada:
#
# «matrizEntrada»: variable del tipo «dataTable» que contiene una columna
#                  «Secuencia» en la que están las secuencias de navegación
# Variable de salida: 
#
#
# ------------------------ Funciones
# Función que rellena la matriz de clicks
# Filas: secuencias
# Columnas: tantas como posibles acciones

# el resto de la estructura de datos queda con ceros

# creaMatrizNavegacion <- function(matrizSalida, matrizEntrada, codificacion) {
creaMatrizNavegacion <- function(matrizEntrada, codificacion) {
  
          # Se crea dataframe vacío
          matrizSalida <- data.frame(matrix(ncol = 
                                      max(matrizEntrada[["Longitud"]]), nrow=0))
          
          # Se nombran las columnas
          colnames(matrizSalida) <- c(1:max(matrizEntrada[["Longitud"]]))
          fila <- 0
          columna <- 0
          
          # Iteración para cada elemento de la columna «Secuencia»
          sapply(matrizEntrada[["Secuencia"]], 
                 function (lista) {
                           fila <<- fila + 1 # empleamos <<- para asignar variable en entorno padre
                           
                           # Iteración para cada paso de la secuencia en cuestión
                           sapply(lista, 
                                  function(elemento) {
                                            columna <<- columna + 1
                                            accion <- which(elemento==codificacion)
                                            # empleamos <<- para asignar variable en entorno padre
                                            matrizSalida[fila, columna] <<- accion
                                  })
                           columna <<- 0
                 })
          # Este es el modo más rápido de convertir en cero los NA
          for (i in seq_along(matrizSalida)) 
                    set(matrizSalida, i=which(is.na(matrizSalida[[i]])), j=i, value=0)
          
          return(matrizSalida)
}

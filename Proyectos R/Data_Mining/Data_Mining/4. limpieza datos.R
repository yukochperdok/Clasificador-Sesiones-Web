#### Limpiamos los datos en base a 3 reglas:
# Guardamos una copia del original:
secuenciasOriginal <- secuencias


#### 1. Secuencias que tienen una longitud de 1:
secuencias<-secuencias[secuencias$Longitud>1,]


#### 2. Secuencias cuyo estado inicial no tiene sentido de negocio:
#     action_node_id           action_node
#                 80                addBet
#                 84            addBetLive
#                102       ContinueBetting
#                190                LogOut
#                101              CloseBet
#                100           CleanTicket
#                 85      addBetRealMadrid
#                 96    ChangeAmountTicket
#                 83            addBetHorG
#                 90          betCompleted
#                 98         ChangeTypeBet
#                 95  cancelFreeBetsTicket
#                130        errorMsgTicket
#                103    CreateLocalPayment
#                105      DepositPaymentOK
#                185       InsertAmountAut

acciones.eliminar <- c(c(80:87),c(90,93:99),c(100:105),130,185,186,190)
secuencias_firstAction<-lapply(secuencias$Secuencia, function(l) l[[1]])
secuencias <- secuencias[which(!secuencias_firstAction %in% acciones.eliminar),]

# Comprobamos que la eliminacion se hace correctamente:
acciones.eliminar %in% lapply(secuencias$Secuencia, function(l) l[[1]])


#### 3. Secuencias que tienen un betCompleted sin tener CloseBet
# Numero de personas que sin cerrar apuesta tienen accion de completarla (NO TIENE SENTIDO)
#pos.eliminar<-which(unlist(lapply(secuencias$Secuencia, 
#                           function(x){
#                             !(101 %in% x) && 90 %in% x
#                           })))

#secuencias<-secuencias[-pos.eliminar]

#### 4. Outlayers por longitud:

# Según se ha analizado en el scrip exploracionDatos.R se han de eliminar las secuencias que superen
# los 386 pasos que corresponde con 8 veces el RIC de la distribución de frecuencias de las longitudes
# de secuencias. Estas secuencias que se eliminan suponen un 1 % una vez ejecutados los pasos 1 y 2 del
# presente script.
secuencias<-secuencias[secuencias$Longitud<386,]


# Comprobamos que % de la muestra se ha eliminado
print(paste("Secuencias limpias: queda un ",(dim(secuencias)[1]/dim(secuenciasOriginal)[1]*100),"%")) #90.68 %
rm(secuenciasOriginal)
rm(secuencias_firstAction)

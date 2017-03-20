################################################################################################################
################## PRIMERA EXPLORACION DE LOS DATOS  ###########################################################
################################################################################################################
#  En este fichero hemos elegido un dia al azar: 27/12 (Martes) y vamos a cargar
#  todas sus secuencias y vamos a explorar y enterder los datos.
#  Sera el primer dia que carguemos y analicemos, por lo tanto primero haremos una
#  primera exploracion de las dispersion de longitudes que tienen las secuencias
#  La idea es poder detectar outliers
#  Posteriormente haremos un analisis en varios sentidos, que repetiremos con mas dias (fines de semana, etc..)
#
#  Este analisis consistira en lo siguiente:
#       1. Analisis de limpieza:
#       Lo primero que vamos a hacer es tratar los posibles casos a limpiar:
#           a. Se analizarán secuencias de 1, 2 o 3 pasos
#           b. Se analizaran el primer paso de todas las secuencias
#           c. Se analizarán outliers por longitud de secuencia
#
#       2. Analisis de apuestas por longitud.
#       3. Analisis porcentajes apuestas.
#       4. Analisis apuestas por deporte.
#       5. Analisis porcentajes logados/no logados
#
#  Las conclusiones se indicaran al finalizar cada punto.
#  La idea fundamental es conocer los datos, posibles valores y sus patrones. Y ante todo identificar metricas
#  o KPI's interesantes para negocio.
#  Esto es una exploracion inicial de un dia al azar pero obviamente se han de ver mas dias y ver
#  el comportamiento de los datos por dia de la semana para tener claro si se comportan de forma diferente o no los usuarios.
#  Con esta informacion seremos capaces de identificar una muestra representativa para nuestro algoritmo de clusterizacion de sesiones.
################################################################################################################
################################################################################################################

# Limpiar workspace
rm(list=ls())
setwd("D:/Pedro/Master MBIT/Proyecto Master/PROYECTO CODERE/Exploracion Datos/Data Mining/Exploracion Datos")
ficheros <- list.files()

is.installed <- function(paquete) is.element (
  paquete, installed.packages())

if(!is.installed("ggplot2"))
  install.packages("ggplot2")
if(!is.installed("gridExtra"))
  install.packages("gridExtra")
if(!is.installed("data.table"))
  install.packages("data.table")

require(ggplot2)
require(gridExtra)
require(data.table)

####################################################################################
#################### CARGA Y TRATAMIENTO DATOS #####################################
####################################################################################
load("D:/Pedro/Master MBIT/Proyecto Master/PROYECTO CODERE/Exploracion Datos/Data Mining/Cargas de Datos/secuencias27-12.RData")
dim(secuencias)
head(secuencias,10)
#####################################################################################
########################## EXPLORACION DE LOS DATOS #################################
#####################################################################################
# IMP: Para nosotros la accion de apostar estará definida como betCompleted, ya que es la que realmente accarea cash.
# Un usuario ha podido añadir apuesta(s) mediante las siguientes acciones:

#                action_node action_node_id
#                     addBet             80
#  AddBetCombForecastElement             81
#AddBetDirectForecastElement             82
#                 addBetHorG             83
#                 addBetLive             84
#           addBetRealMadrid             85
#    AddForecastOrTricastBet             86
#          addFreeBetsTicket             87

# Y podra tener la intencion de cerrar la apuesta con la accion:

#                action_node action_node_id
#                   CloseBet            101

# Pero dicha apuesta no estará nunca cerrada hasta que se complete la apuesta por parte del sistema:

#                action_node action_node_id
#               betCompleted             90

# Han podido producirse errores: 130 - errorMsgTicket o incluso rechazar la apuesta o salir del sistema.
# Por lo tanto nuestro estado objetivo será betCompleted (90).



# ------------------------ 1. Analisis de limpieza:------------------------------------
######## Lo primero que vamos a hacer es tratar los posibles casos a limpiar:
######## a. Se analizarán secuencias de 1, 2 o 3 pasos
######## b. Se analizaran el primer paso de todas las secuencias
######## c. Se analizarán outliers por longitud de secuencia

# Nos quedamos con el tamaño original de secuencias
tam.secuencias.original<-dim(secuencias)[1]
tam.secuencias.original # 14620



# --------- 1a y 1b. Analisis secuencias cortas:

# Analizaremos las secuencias de longitud corta en funcion de sus estados iniciales  ya que 
# hemos visto que tienen un porcentage muy alto con respecto a la muestra
length(which(secuencias$Longitud<=3))/dim(secuencias)[1]*100 # Casi un 19.32%


##### Tratamiento secuencias de 1 solo paso: 

# Hemos visto que existen una gran cantidad de secuencias de un solo paso. Veamos
# que nos podemos encontrar:
length(which(secuencias$Longitud==1)) # 1547 son solo de un paso !!!!
length(which(secuencias$Longitud==1))/dim(secuencias)[1]*100 # Un 10.5% de la muestra

merge(tablaCodificacion,cbind(action_node_id=unique(secuencias[secuencias$Longitud<=1,]$Secuencia)),by="action_node_id")
# 42 posibles entradas de un solo paso:
#  action_node_id                     action_node
#               1                   AcceptNewOdds
#              24 AccessFromCarrusel:DirectosPage
#              29               AccessLocalCodere
#              38                  AccessToCasino
#              48          AccessToGameCasino: pc
#              49        AccessToGameSlots: movil
#              64          AccessToRealMadridPage
#              67      AccessToRegisterFromButton
#              70                   AccessToSlots
#              71                  AccessToTicket
#              73              AccessToViewTicket
#              80                          addBet
#              84                      addBetLive
#              96              ChangeAmountTicket
#              98                   ChangeTypeBet
#             100                     CleanTicket
#             102                 ContinueBetting
#             108       DirectAccessEvent: soccer
#             120      DirectAccessLeague: soccer
#             122                        Directos
#             124                EarlyCashOutCall
#             129           EarlyCashOutNoAbility
#             136       Go to: AccessToBetHistory
#             149    Go to: ChangeSportInLivePage
#             153    Go to: DeleteElementOfTicket
#             162             Go to: GoToLivePage
#             165             Go to: goToRegister
#             169                 Go to: LoadPage
#             174            Go to: OpenSportMenu
#             177           Go to: RedirectDevice
#             183                   goToIndexPage
#             187                    loadHomePage
#             197                  RefreshBalance
#             201         SelectEvent: basketball
#             210             SelectEvent: soccer
#             218     SelectEventLive: basketball
#             223         SelectEventLive: soccer
#             224         SelectEventLive: tennis
#             247        SelectMarket: basketball
#             252            SelectMarket: soccer
#             257         SelectSport: basketball
#             266             SelectSport: soccer


# Recogemos todos las secuencias de un solo paso, para hacer un histograma
# y poder ver cuales son mas frecuentes
secuencias1SoloPaso <- data.frame(matrix(unlist(secuencias[secuencias$Longitud<=1,]$Secuencia), byrow=T))
colnames(secuencias1SoloPaso)<-c("Secuencia")
length(secuencias1SoloPaso$Secuencia) # 1547 secuencias de un solo paso

sort(table(secuencias1SoloPaso$Secuencia), decreasing = TRUE)
# Vemos que las mas frecuentes son: 
#            187                    loadHomePage --> 900 Apariciones
#            169                 Go to: LoadPage --> 375 Apariciones
#             29               AccessLocalCodere --> 41 Apariciones
#            108       DirectAccessEvent: soccer --> 38 Apariciones
#             67      AccessToRegisterFromButton --> 37 Apariciones
#            183                   goToIndexPage --> 24 Apariciones
#            149    Go to: ChangeSportInLivePage --> 22 Apariciones
#            136       Go to: AccessToBetHistory --> 18 Apariciones

# La gran mayoria de los estados iniciales de secuencias de un paso corresponden a accesos a la pagina principal
# en concreto casi el 86% de los primeros pasos son a la pagina principal o al registro.
# Luego tambien hay accesos al history y al ev ento de soccer.
length(secuencias1SoloPaso[secuencias1SoloPaso$Secuencia %in% c(187,169,67,183),])/dim(secuencias1SoloPaso)[1]*100 #86.36


# Representamos en un grafico de barras
c <- ggplot(secuencias1SoloPaso, aes(factor(Secuencia))) + labs(title="Acc.Iniciales Secuencias 1 solo paso", x="Acciones", y = "Apariciones")
c + geom_bar(fill="steelblue") + coord_flip() 



c <- ggplot(secuencias1SoloPaso, aes(factor(Secuencia), fill=factor(Secuencia))) + labs(title="Acc.Iniciales Secuencias 1 solo paso", x="Acciones", y = "Apariciones")
c + geom_bar() + coord_flip() + scale_fill_discrete("Acciones", 
                                                    breaks=unlist(unique(secuencias1SoloPaso$Secuencia)),
                                                    labels=unlist(unique(secuencias1SoloPaso$Secuencia)))


# Vamos a agrupar todas las que tienen pocas apariciones en un mismo grupo
secuencias1SoloPaso$Grupo <- unlist(lapply(secuencias1SoloPaso$Secuencia,
                                           function(x)
                                             if(table(secuencias1SoloPaso$Secuencia)[toString(x)] > 7)
                                               return(x)
                                           else
                                             return("Menos comunes")))

c <- ggplot(secuencias1SoloPaso, aes(factor(Grupo), fill=factor(Secuencia))) + labs(title="Acc.Iniciales Secuencias 1 solo paso", x="Acciones", y = "Apariciones")
c + geom_bar() + coord_flip() + scale_fill_discrete("Acciones menos comunes", 
                                                    breaks=unlist(unique(secuencias1SoloPaso[secuencias1SoloPaso$Grupo=="Menos comunes",]$Secuencia)),
                                                    labels=unlist(unique(secuencias1SoloPaso[secuencias1SoloPaso$Grupo=="Menos comunes",]$Secuencia)))

# Vemos porcentajes con respecto al total de la muestra:
length(which(secuencias1SoloPaso$Grupo=="Menos comunes"))/dim(secuencias)[1]*100 # 0.62%
length(secuencias1SoloPaso$Secuencia)/dim(secuencias)[1]*100 # 10.5%


###CONCLUSION: La realidad es que el 10.5% de las secuencias solo tienen un paso. De las cuales un 0.62% son muy poco comunes. 
# Estas ultimas, que se pueden eliminar perfectamente de la muestra, no son casos representativos generan ruido porque son probablemente errores de acceso.
# La cuestion es que hacer con los mas comunes (187,169,67,183) que son accesos al Home o al registro que luego se van de la pagina.
# En nuestro caso vamos a tomar la misma decision (quitarlos de la muestra) puesto que para nosotros no suponen un patron de comportamiento,
# puesto que no podemos realmente distinguir los usuarios de codere y los que han sido errores.
# Por lo tanto vamos a considerar como casos no interesantes para el estudio todas las secuencias de un solo paso: 10.5% de la muestra.
secuenciasLimpias<-secuencias[secuencias$Longitud>1,]
# Comprobamos que hemos borrado correctamente
dim(secuenciasLimpias)[1]+1547 == dim(secuencias)[1]

##### FIN Tratamiento secuencias de 1 solo paso.



##### Tratamiento secuencias por primer paso de la secuencia

# Una vez que tenemos eliminadas las secuencias de un solo paso que consideramos ruido
# vamos a ver de todas las secuencias cuales son los estados iniciales mas comunes:

# IMP: Aqui ya trabajamos con la variable 'secuenciasLimpias'
dim(secuenciasLimpias)[1] # 13073

# Cogemos la primera accion de todas las secuencias y miramos sus frecuencias
secuencias_firstAction<-lapply(secuenciasLimpias$Secuencia, function(l) l[[1]])
tabla_frecuencias_firstAction<-sort(table(unlist(secuencias_firstAction)),decreasing = TRUE)
tabla_frecuencias_firstAction

# Los mas comunes son:
#   187    88   174   197   183   136   149   169    67   223   122    70    80   210   160
# 10357   403   309   217   214   194   166   141   133    77    48    47    44    43    41

#    24   177   218    84   102    26   252   266   108    29   286   120   143   201    71
#    40    38    38    37    34    25    25    23    21    20    20    19    18    17    15

# Y hay bastantes poco comunes:
#   83    90    98   104   107   123   124   139   142   157   159   161   225   226   227 
#    2     2     2     2     2     2     2     2     2     2     2     2     2     2     2 

#   23    33    39    41    46    49    51    61    76    78    95   103   105   106   116 
#    1     1     1     1     1     1     1     1     1     1     1     1     1     1     1 

#  130   135   137   150   156   158   166   167   178   185   189   195   199   205   211 
#    1     1     1     1     1     1     1     1     1     1     1     1     1     1     1 

#  212   214   221   228   235   245   248   255   261   279   281   283 
#    1     1     1     1     1     1     1     1     1     1     1     1

# Los vemos por descripcion
df_secuencias_firstActions<-data.frame(primeraAccion=matrix(as.numeric(row.names(tabla_frecuencias_firstAction)), byrow = T), apariciones=matrix(unlist(tabla_frecuencias_firstAction), byrow = T))
df_secuencias_firstActions$primeraAccionName<-lapply(df_secuencias_firstActions$primeraAccion, function(x) return(toString(tablaCodificacion[tablaCodificacion$action_node_id==x,]$action_node)))
df_secuencias_firstActions
# Tendriamos 117 posibles estados iniciales
#    primeraAccion apariciones                            primeraAccionName
#1             187       10357                                 loadHomePage
#2              88         403                                 attemptLogin
#3             174         309                         Go to: OpenSportMenu
#4             197         217                               RefreshBalance
#5             183         214                                goToIndexPage
#6             136         194                    Go to: AccessToBetHistory
#7             149         166                 Go to: ChangeSportInLivePage
#8             169         141                              Go to: LoadPage
#9              67         133                   AccessToRegisterFromButton
#10            223          77                      SelectEventLive: soccer
#11            122          48                                     Directos
#12             70          47                                AccessToSlots
#13             80          44                                       addBet
#14            210          43                          SelectEvent: soccer
#15            160          41                      Go to: Fútbol_Destacado
#16             24          40              AccessFromCarrusel:DirectosPage
#17            177          38                        Go to: RedirectDevice
#18            218          38                  SelectEventLive: basketball
#19             84          37                                   addBetLive
#20            102          34                              ContinueBetting
#21             26          25           AccessFromCarrusel:misApuestasPage
#22            252          25                         SelectMarket: soccer
#23            266          23                          SelectSport: soccer
#24            108          21                    DirectAccessEvent: soccer
#25             29          20                            AccessLocalCodere
#26            286          20             SelectSportFromSportmenu: soccer
#27            120          19                   DirectAccessLeague: soccer
#28            143          18                  Go to: Baloncesto_Destacado
#29            201          17                      SelectEvent: basketball
#30             71          15                               AccessToTicket
#31            162          15                          Go to: GoToLivePage
#32             11          14                   AccessFromCarrusel: soccer
#33            224          14                      SelectEventLive: tennis
#34            190          11                                       LogOut
#35            257          11                      SelectSport: basketball
#36            101           9                                     CloseBet
#37             60           8                        AccessToNBAEventoPage
#38            100           8                                  CleanTicket
#39             73           7                           AccessToViewTicket
#40            138           7                    Go to: AccessToLastMinute
#41            260           7                SelectSport: greyhound_racing
#42             10           6               AccessFromCarrusel: basketball
#43             38           6                               AccessToCasino
#44            277           5         SelectSportFromSportmenu: basketball
#45              1           4                                AcceptNewOdds
#46             28           4          AccessFromCarrusel:UltimoMinutoPage
#47            129           4                        EarlyCashOutNoAbility
#48            153           4                 Go to: DeleteElementOfTicket
#49              3           3                            AccessExtLivePage
#50             35           3           AccessSportBySporthandleEx: soccer
#51             85           3                             addBetRealMadrid
#52             96           3                           ChangeAmountTicket
#53            175           3                          Go to: OpenUserMenu
#54            206           3                      SelectEvent: ice_hockey
#55            247           3                     SelectMarket: basketball
#56            262           3                    SelectSport: horse_racing
#57            289           3                                startSearched
#58             14           2            AccessFromCarrusel:btnIdIcoBasket
#59             27           2                 AccessFromCarrusel:SlotsPage
#60             50           2                        AccessToGameSlots: pc
#61             83           2                                   addBetHorG
#62             90           2                                 betCompleted
#63             98           2                                ChangeTypeBet
#64            104           2                                DepositOnline
#65            107           2                DirectAccessEvent: basketball
#66            123           2                          EarlyCashOutAbility
#67            124           2                             EarlyCashOutCall
#68            139           2                Go to: AccessToOnlinePayments
#69            142           2                            Go to: Baloncesto
#70            157           2                                Go to: Fútbol
#71            159           2 Go to: Fútbol americano NFL / NCAA_Destacado
#72            161           2                        Go to: GoToHorsesPage
#73            225           2                  SelectEventLive: volleyball
#74            226           2         SelectEventLiveFromIndex: basketball
#75            227           2             SelectEventLiveFromIndex: soccer
#76             23           1               AccessFromCarrusel:ContactPage
#77             33           1       AccessSportBySporthandleEx: basketball
#78             39           1                      accessToCheckCodereCard
#79             41           1                       AccessToCobWithHalcash
#80             46           1                    AccessToCreditCardDeposit
#81             49           1                     AccessToGameSlots: movil
#82             51           1                              accessToGetCard
#83             61           1                              AccessToOddType
#84             76           1                           ActivateDesElement
#85             78           1                         ActivateDesStreaming
#86             95           1                         cancelFreeBetsTicket
#87            103           1                           CreateLocalPayment
#88            105           1                             DepositPaymentOK
#89            106           1                  DirectAccessEvent: Partidos
#90            116           1               DirectAccessLeague: basketball
#91            130           1                               errorMsgTicket
#92            135           1                  Go to: AccessOnlineDeposits
#93            137           1                     Go to: AccessToDemoSlots
#94            150           1                                Go to: Dardos
#95            156           1                          Go to: Football BGI
#96            158           1           Go to: Fútbol americano NFL / NCAA
#97            166           1                    Go to: Hockey sobre hielo
#98            167           1          Go to: Hockey sobre hielo_Destacado
#99            178           1                           Go to: Rugby Union
#100           185           1                              InsertAmountAut
#101           189           1                                      LoginOK
#102           195           1              p_SelectEvent: greyhound_racing
#103           199           1                 SelectEvent: artes_marciales
#104           205           1                        SelectEvent: handball
#105           211           1                          SelectEvent: tennis
#106           212           1                      SelectEvent: volleyball
#107           214           1                 SelectEventFromIndex: soccer
#108           221           1                  SelectEventLive: ice_hockey
#109           228           1             SelectEventLiveFromIndex: tennis
#110           235           1                 SelectLeaguePage: Baloncesto
#111           245           1              SelectMarket: american_football
#112           248           1                        SelectMarket: esports
#113           255           1               SelectSport: american_football
#114           261           1                        SelectSport: handball
#115           279           1            SelectSportFromSportmenu: esports
#116           281           1           SelectSportFromSportmenu: handball
#117           283           1         SelectSportFromSportmenu: ice_hockey

# Comprobamos que el calculo es correcto
sum(df_secuencias_firstActions$apariciones)==dim(secuenciasLimpias)[1]

# Observamos que hay una gran mayoria de secuencias que acceden por la pagina de LoadHome o de registro:
sum(df_secuencias_firstActions[df_secuencias_firstActions$primeraAccion %in% c(187,169,88,67,183),]$apariciones)/dim(secuenciasLimpias)[1]*100 #86.03
# Un 86% de los usuarios acceden por el LoadHome (o por el registro).

# Pero tambien vemos que con alguna frecuencia hay usuarios que acceden a paginas directamente, sin pasar por el LoadHome:
# Como por ejemplo: AccessToBetHistory, RefreshBalance, ChangeSportInLivePage, OpenSportMenu o soccer.
sum(df_secuencias_firstActions[df_secuencias_firstActions$primeraAccion %in% c(197,136,149,223,174),]$apariciones)/dim(secuenciasLimpias)[1]*100 #7.36%
# Pero realmente son un 7.3% de la muestra

# Y otros muchos accesos y eventos muchisimos menos frecuentes, de los cuales algunos de ellos no tienen ni sentido de negocio:
#     primeraAccion apariciones                            primeraAccionName
# 13             80          44                                       addBet
# 19             84          37                                   addBetLive
# 20            102          34                              ContinueBetting
# 34            190          11                                       LogOut
# 36            101           9                                     CloseBet
# 38            100           8                                  CleanTicket
# 51             85           3                             addBetRealMadrid
# 52             96           3                           ChangeAmountTicket
# 61             83           2                                   addBetHorG
# 62             90           2                                 betCompleted
# 63             98           2                                ChangeTypeBet
# 86             95           1                         cancelFreeBetsTicket
# 91            130           1                               errorMsgTicket
# 88            105           1                             DepositPaymentOK
# 100           185           1                              InsertAmountAut

# Esto es posible por 2 situaciones:
# a) La sesion caduca en medio de una navegacion por un timeout y se le aplica otra.
# b) Trazas cortadas o no correctas en su volcado a logs.

# En cualquier caso no definen un comportamiento de un usuario sino de una accion que se ha quedado a medias.
sum(df_secuencias_firstActions[df_secuencias_firstActions$primeraAccion %in% c(80,84,102,190,101,100,85,96,83,90,98,95,130,103,105,185),]$apariciones)/dim(secuenciasLimpias)[1]*100 #1.22%
# Estos casos suponen un 1% de la muestra actual y deben ser eliminadas.

# El resto aunque menos frecuentes, son comportamientos validos de navegacion, que aunque haya quedado a medias la navegacion como tal
# inducen a un comportamiento distinto. Es decir es probable que el usuario o ha accedido directamente a esa pagina/opcion o bien
# transcurrido un tiempo ha decidido hacer otra navegacion diferente a la anterior y por lo tanto otro patron diferente de comportamiento.



# Representamos:
c <- ggplot(df_secuencias_firstActions, aes(factor(primeraAccion, levels = primeraAccion[order(apariciones)]),apariciones)) + labs(title="1er paso todas las secuencias", x="Acciones", y = "Apariciones")
c + geom_bar(stat="identity",fill="steelblue") + coord_flip() 
# No se ve nada

# Intentamos representar las mas comunes
c <- ggplot(df_secuencias_firstActions[1:20,], aes(factor(primeraAccion,levels = primeraAccion[order(apariciones)]),apariciones, fill=factor(primeraAccion))) + labs(title="1er paso todas las secuencias (Mas comunes)", x="Acciones", y = "Apariciones")
c + geom_bar(stat="identity") + coord_flip() + scale_fill_discrete("Acciones", 
                                                                   breaks=unlist(unique(df_secuencias_firstActions[1:20,]$primeraAccion)),
                                                                   labels=unlist(unique(df_secuencias_firstActions[1:20,]$primeraAccion)))

# Vamos a agrupar para verlo mejor:
df_secuencias_firstActions$Grupo <- unlist(lapply(df_secuencias_firstActions$primeraAccion,
                                                  function(x)
                                                    if(df_secuencias_firstActions[df_secuencias_firstActions$primeraAccion==x,]$apariciones > 30)
                                                      return(x)
                                                  else
                                                    return("Menos comunes")))

c <- ggplot(df_secuencias_firstActions, aes(factor(unlist(Grupo),levels = unique(Grupo[order(apariciones)])),apariciones, fill=factor(primeraAccion))) + labs(title="1er paso todas las secuencias", x="Acciones", y = "Apariciones")
c + geom_bar(stat="identity") + coord_flip() + scale_fill_discrete("Acciones menos comunes", 
                                                                   breaks=unlist(unique(df_secuencias_firstActions[df_secuencias_firstActions$Grupo=="Menos comunes",]$primeraAccion)),
                                                                   labels=unlist(unique(df_secuencias_firstActions[df_secuencias_firstActions$Grupo=="Menos comunes",]$primeraAccion)))

# Se puede mejorar el grafico pero vemos la alta probabilidad del evento 187 frente al resto.

#### CONCLUSION:
# Aproximadamente el 86% de la muestra tienen como primer paso una accion sobre el LoadHome (o con el registro), mas del 7.3% tienen como primer paso otra pagina diferente al loadHome (AccessToBetHistory, RefreshBalance, ChangeSportInLivePage, OpenSportMenu o soccer),
# y casi un 1% son operaciones poco frecuentes, algunas de ellas sin sentido de negocio.
# Por ello vamos a identificar todas las acciones que no se pueden cortar en medio de un comportamiento 
# y que por lo tanto no pueden ser comienzo de una secuencia:

# tablaCodificacion
#     action_node               action_node_id
#              80                       addBet
#              81    AddBetCombForecastElement
#              82  AddBetDirectForecastElement
#              83                   addBetHorG
#              84                   addBetLive
#              85             addBetRealMadrid
#              86      AddForecastOrTricastBet
#              87            addFreeBetsTicket
#              90                 betCompleted
#              93  cancelCobOnlineFromDeposits
#              94      cancelCobOnlineFromMenu
#              95         cancelFreeBetsTicket
#              96           ChangeAmountTicket
#              97          changePinCodereCard
#              98                ChangeTypeBet
#              99           checkFreeBetTicket
#             100                  CleanTicket
#             101                     CloseBet
#             102              ContinueBetting
#             103           CreateLocalPayment
#             104                DepositOnline
#             105             DepositPaymentOK
#             130               errorMsgTicket
#             185              InsertAmountAut
#             186         InsertAmountAutLocal
#             190                       LogOut


# Que seguramente se deban a que la traza se ha cortado o se ha volcado mal o bien a que ha habido un timeout en la sesion y se ha adjudicado otra, pero
# independientemente del motivo no empiezan un comportamiento nuevo, un patron nuevo, por lo tanto generan ruido => Han de eliminarse de la muestra 
acciones.eliminar <- c(c(80:87),c(90,93:99),c(100:105),130,185,186,190)

# Antes de eliminarlas observamos de que tipo son...
pos.eliminar <- which(secuencias_firstAction %in% acciones.eliminar)
mean(secuenciasLimpias[pos.eliminar,]$Longitud)
boxplot(secuenciasLimpias[pos.eliminar,]$Longitud) 
# Son longitudes de secuencias un poco mas altas que la media. 


# Eliminamos de cualquier forma estas secuencias sin sentido de negocio
secuenciasLimpias <- secuenciasLimpias[which(!secuencias_firstAction %in% acciones.eliminar),]
dim(secuenciasLimpias)[1]#12911

# Comprobamos que la eliminacion se hace correctamente:
acciones.eliminar %in% lapply(secuenciasLimpias$Secuencia, function(l) l[[1]])

# Se han eliminado otro 1.10% con respecto a la muestra original
length(pos.eliminar)/dim(secuencias)[1]*100

##### FIN Tratamiento secuencias por primer paso de la secuencia


##### Tratamiento de secuencias de 2 o 3 pasos

# Una vez que se han descartado:
# a) El 10.5% de la muestra original por ser de longitud 1.
# b) El 1.10% de la muestra original puesto que su inicio de secuencia no tiene sentido de negocio
# Debemos ver como quedan las secuencias de tamaño 2 y 3 que tenemos bastantes.

# Comparamos las de la muestra original con las de la muestra limpia
length(which(secuencias$Longitud==3)) # 691 son de 3 pasos
length(which(secuencias$Longitud==2)) # 588 son de 2 pasos

length(which(secuenciasLimpias$Longitud==3)) # 688 son de 3 pasos
length(which(secuenciasLimpias$Longitud==2)) # 573 son de 2 pasos
# Hemos quitado algunas pero no muchas. Un total de 18.

# Revisamos las combinaciones de 2 pasos
combinaciones2pasos <- function(df_secuencias) {
  secuencias2Pasos <- data.frame(matrix(df_secuencias[df_secuencias$Longitud==2,]$Secuencia, byrow=T))
  colnames(secuencias2Pasos)<-c("Secuencia")
  
  secuencias2Pasos$strSecuencia <- lapply(secuencias2Pasos$Secuencia,function(x)toString(x))
  list_combinaciones<-sort(table(unlist(secuencias2Pasos$strSecuencia)),decreasing = TRUE)
  
  secuencias2Pasos$primerPaso<- unlist(lapply(secuencias2Pasos$Secuencia, function(l) l[1]))
  secuencias2Pasos$segundoPaso<- unlist(lapply(secuencias2Pasos$Secuencia, function(l) l[2]))
  tabla_frecuencias<-table(secuencias2Pasos$primerPaso,secuencias2Pasos$segundoPaso)
  
  
  return(list(strSecuencias=secuencias2Pasos$strSecuencia,list_combinaciones=list_combinaciones,tabla_frecuencias=tabla_frecuencias))
}

# Calculamos las combinaciones y sus frecuencias de 2 pasos. Tanto para la muestra limpia como la total
secuenciasLimpias2Pasos<-combinaciones2pasos(secuenciasLimpias)
secuenciasLimpias2Pasos$list_combinaciones
secuenciasLimpias2Pasos$tabla_frecuencias

secuencias2Pasos<-combinaciones2pasos(secuencias)
secuencias2Pasos$list_combinaciones
secuencias2Pasos$tabla_frecuencias

lattice::levelplot(secuencias2Pasos$tabla_frecuencias , col.regions = heat.colors(100)[length(heat.colors(100)):1] ,aspect="fill",
                   main=list(label="Correlacion de pasos",cex=0.75),
                   xlab=list(label="Primer paso", cex=0.75),
                   ylab=list(label="Segundo paso",cex=0.75),
                   scales=list(cex=0.5))

# Vemos que la mayoria de las combinaciones empiezan por 187 o 169(loadHomePage), y en menor medida 108(Directos soccer) y 88(intento de login).
# Pero luego existen muchas combinaciones muy poco frecuentes.

# Vemos las combinaciones que nos hemos quitado con los tratamientos anteriores
unlist(setdiff(secuencias2Pasos$strSecuencia,secuenciasLimpias2Pasos$strSecuencia))
# [1] "101, 90"  "190, 183" "84, 221"  "80, 71"   "102, 197" "102, 183" "80, 80"   "102, 174"
# [9] "101, 257" "190, 187" "84, 71"
# Todas ellas por ser combinaciones que empiezan en un estado que no tiene sentido de negocio: (102 - ContinueBetting), (101 - CloseBet), (80 y 84 - addBet)


# Revisamos las combinaciones de 3 pasos
combinaciones3pasos <- function(df_secuencias) {
  secuencias3Pasos <- data.frame(matrix(df_secuencias[df_secuencias$Longitud==3,]$Secuencia, byrow=T))
  colnames(secuencias3Pasos)<-c("Secuencia")
  
  secuencias3Pasos$strSecuencia <- lapply(secuencias3Pasos$Secuencia,function(x)toString(x))
  list_combinaciones<-sort(table(unlist(secuencias3Pasos$strSecuencia)),decreasing = TRUE)
  
  secuencias3Pasos$primerPaso<- unlist(lapply(secuencias3Pasos$Secuencia, function(l) l[1]))
  secuencias3Pasos$segundoPaso<- unlist(lapply(secuencias3Pasos$Secuencia, function(l) l[2]))
  secuencias3Pasos$tercerPaso<- unlist(lapply(secuencias3Pasos$Secuencia, function(l) l[3]))
  tabla_frecuencias<-table(secuencias3Pasos$primerPaso,secuencias3Pasos$segundoPaso,secuencias3Pasos$tercerPaso)
  
  
  return(list(strSecuencias=secuencias3Pasos$strSecuencia,list_combinaciones=list_combinaciones,tabla_frecuencias=tabla_frecuencias))
}

secuenciasLimpias3Pasos<-combinaciones3pasos(secuenciasLimpias)
secuenciasLimpias3Pasos$list_combinaciones
secuenciasLimpias3Pasos$tabla_frecuencias

secuencias3Pasos<-combinaciones3pasos(secuencias)
secuencias3Pasos$list_combinaciones
secuencias3Pasos$tabla_frecuencias

unlist(setdiff(secuencias3Pasos$strSecuencia,secuenciasLimpias3Pasos$strSecuencia))
# [1] "102, 38, 48"   "102, 183, 183" "101, 90, 102"

# Vuelve a pasar lo mismo, ahora la gran mayoria de las combinaciones empiezan en 187(loadhome) y luego
# hay muchas combinaciones muy poco frecuentes.
# Lo que si observamos es que hemos quitado 3 combinaciones que no tenian sentido de negocio.


#### CONCLUSION: 
# La gran mayoria de las combinaciones de 2 o 3 pasos empiezan por el LoadHome: 187.
# Y luego existen muchisimas combinaciones de frecuencias muy bajas. Esto pasará con todas las longitudes en general.
# Se podrian eliminar estas combinaciones de frecuencia tan baja, pero la realidad es que tienen sentido de negocio y como tal es
# un comportamiento valido que ira a uno u otro cluster y que por su baja frecuencia no distorsionará demasiado el modelo de clusterizacion.
# Por ello decidimos no quitarlas.

##### FIN Tratamiento de secuencias de 2 o 3 pasos



# --------- 1c. Analisis outliers por longitud:
# Una vez que hemos limpiado las secuencias de longitud 1 y las secuencias cuyo primer paso no es logico en cuanto a negocio, 
# actualizamos nuestro dataset de secuencias y analizamos la dispersion de longitudes en busca de outliers.
secuencias <- as.data.table(secuenciasLimpias) 


######### Dispersion Longitudes:

# Longitud media de secuencias
mean(secuencias$Longitud) # 38.123

summary(secuencias$Longitud)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 2.00    7.00   17.00   38.12   41.00 3409.00

boxplot(secuencias$Longitud) # Media clara en 17 y los quantiles definidos entre 7 y 41

# De los cuales:
length(which(secuencias$Longitud>41)) # 3162 son superiores a 41 pasos 
length(which(secuencias$Longitud<7)) # 3062 son inferiores a 7 pasos
# En forma mas extrema si consideramos 2 o 3 pasos poco significativos y mas de 800 poco significativos:
length(which(secuencias$Longitud>=800)) # 19 son superiores a 799 pasos 
length(which(secuencias$Longitud<=3)) # 1261 son inferiores a 3 pasos

###CONCLUSION: Existen muchisimos outlayers superiores que es necesario tratarlos
# Hasta un 1% podemos eliminar de la muestra: nos focalizamos en secuencias largas puesto que las cortas ya las hemos tratado.

## Calculamos el número de secuencias atípicas que hay en función de la longitud
# Para ello calculamos los bigotes del boxplot (1.5 * RIC):
# Restamos al 1º cuartil ly sumamos al 3º 1.5 veces el RIC
maxi <- quantile(secuencias$Longitud,.75)+1.5*IQR(secuencias$Longitud)
mini <- quantile(secuencias$Longitud,.25)-1.5*IQR(secuencias$Longitud)
maxi # 92 Parece a priori un valor demasiado bajo de longitud
mini # -44 Era de suponer que no hubiese secuencias atípìcas por debajo al tener una
# distribución normal tan desplazada a la izquierda. El valor debe tomarse como cero 
# ya que no existen secuencias con longitudes negativas

# Calculamos el número de secuencias que hay fuera de ese 1.5 * RIC
atip <-length(secuencias$Longitud[secuencias$Longitud>maxi])
atip #1118 secuencias

# Calculamos el porcentaje de secuencias atípicas
(atip/nrow(secuencias)) * 100 # 8.65% Es un valor muy alto de secuencias a borrar.

# Probamos con varios valores de multiplicación del RIC hasta llegar a un porcentaje 
# de secuencias inferior al 1% -> encontramos que ese valor es 8
maxi <- quantile(secuencias$Longitud,.75)+9*IQR(secuencias$Longitud)
maxi # 347 pasos
atip <-length(secuencias$Longitud[secuencias$Longitud>maxi])
atip # 118 secuencias
(atip/nrow(secuencias)) * 100 # 0.91% de secuencias

### CONCLUSION: Tras analizar la distribución que siguen las longitudes de secuencias se observa
# que sigue una normal muy desplazada hacia la izquierda debido a la gran cantidad de secuencias 
# que tienen pocos pasos. 
# Si cogemos como atípicos los valores que se encuentran fuera del el 1.5 del RIC nos damos
# cuenta de que hay 1118 secuencias de más de 92 pasos a eliminar, un 8.65% de la muestra.
# Si lo que queremos es solo eliminar hasta un 1% de la muestra tenemos que ir hasta los valores 
# que se encuentran fuera del 9 del RIC: 118 secuencias de más de 347 pasos, 0.91% de la muestra.

secuencias<-secuencias[secuencias$Longitud<347,]


# Comprobamos que % de la muestra se ha eliminado
print(paste("Secuencias limpias: queda un ",(dim(secuencias)[1]/tam.secuencias.original*100),"%")) #87.50 %
# Es decir nos hemos quitado un 12.5% de la muestra.

# ------------------------ FIN Analisis de limpieza:------------------------------------




# ------------------ 2. Analisis de apuestas por longitud:------------------------------
########Tabla de frecuencias segun Longitud

secuencias0BetCompleted <- secuencias[BetCompleted==0,,]
secuencias1BetCompleted <- secuencias[BetCompleted==1,,]

# Aprovechamos la función histograma para partir los datos según la longitud de la navegación
# Usuarios Sin apuestas:
histSin <- hist(secuencias0BetCompleted$Longitud, 
                breaks=c(min(secuencias0BetCompleted$Longitud), 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, max(secuencias0BetCompleted$Longitud)))
frecsSin<-data.frame(histSin$breaks[-1], histSin$counts)
colnames(frecsSin) <- c("rango", "counts")
frecsSin<-frecsSin[order(-frecsSin$counts),]
frecsSin

# Frecuencia absoluta, absoluta acumulada, relativa y relativa acumulada
transform(frecsSin,                                     # la tabla de frecuencias absolutas
          FrecAcum=cumsum(counts),                      # frecuencias absolutas acumuladas
          FrecRel = round(prop.table(counts),2),          # frecuencias relativas
          FrecAcum = cumsum(round(prop.table(counts),2))) # frecuencias relativas acumuladas

# Usuarios con una apuesta:
histCon <- hist(secuencias1BetCompleted$Longitud, 
                breaks=c(min(secuencias1BetCompleted$Longitud), 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, max(secuencias1BetCompleted$Longitud)))
frecsCon<-data.frame(histCon$breaks[-1], histCon$counts)
colnames(frecsCon) <- c("rango", "counts")
frecsCon<-frecsCon[order(-frecsCon$counts),]
frecsCon

transform(frecsCon,                                              # la tabla de frecuencias absolutas
          FrecAcum=cumsum(counts),                               # frecuencias absolutas acumuladas
          FrecRel = round(prop.table(counts),2),                 # frecuencias relativas
          FrecAcum = cumsum(round(prop.table(counts),2))) 

###CONCLUSION: 
# Como podemos ver la mayoria de las secuencias tienen una navegacion relativamente corta: en torno a 20-30 pasos.
# Lo que si es cierto es que hay una diferencia evidante entra los que apuestan o no. Hay mucho que no apuestan 
# con navegacion muy pequeña: Por ejemplo gente que solo hace un acceso al LoadHome por equivocacion.


# Y además factorizamos las secuencias según la longitud
particion <- c(0,20,40,60,80,100, max(secuencias$Longitud))
secuencias$Grupo <- 
  cut(secuencias$Longitud, particion)
boxplot(Longitud ~ Grupo, data=secuencias, horizontal = TRUE, ylim=c(0,100))


# Gráficas Apuesta/ No apuesta - Longitud
# Cálculo del promedio de apuestas por tramo de longitud

# Creamos columna de status
# Status: Si hay o no BetCompleted. Si lo hay, Status vale 1, en el otro caso vale 0.
secuencias$Status <- unlist(lapply(1:length(secuencias$Secuencia),
                                   function(i)
                                     if(secuencias$BetCompleted[i] == 0)
                                       return(0)
                                   else
                                     return(1)))
mediasBetCompleted <- 
  unlist(lapply(levels(factor(secuencias$Grupo)), 
                function(grupo) 
                  mean(secuencias[BetCompleted != 0 & 
                                    Grupo == grupo]$BetCompleted)))
# ggplot() + geom_line(data = as.data.frame(mediasBetCompleted),aes(x=levels(factor(secuencias$Grupo)), y=mediasBetCompleted))

grafoMultiple <- list(
  ggplot() + geom_bar(data = secuencias,
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


###CONCLUSION: 
# Es clarisimo que la longitud incide de forma muy importante para hacer una apuesta. 
# Cada tramo de longitud va aumentando la relacion de apuesta y no apuesta lo cual se ve perfectamente en el segundo grafico.
# ------------------ FIN Analisis de apuestas por longitud:------------------------------





# ---------------------- 3. Analisis porcentajes apuestas:------------------------------

# Numero de secuencias diferentes
dim(secuencias)[1]#12793 

# Numero de apuestas
num_apuestas<-sum(secuencias[secuencias$BetCompleted>=1]$BetCompleted)
num_apuestas #7687

# Numero de personas que apuestan
num_apostantes<-length(secuencias[secuencias$BetCompleted>=1]$BetCompleted)
num_apostantes #3724

# Media de apuestas por persona:
num_apuestas/num_apostantes #2.06

# Porcentaje apostantes:
num_apostantes/dim(secuencias)[1]*100 #29.10%

# Numero de personas que NO apuestan
num_no_apostantes<-length(secuencias[secuencias$BetCompleted==0]$BetCompleted)
num_no_apostantes #9069

# Porcentaje NO apostantes:
num_no_apostantes/dim(secuencias)[1]*100 #70.89%

#
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
# ---------------------------------------------
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
# ---------------------------------------------
mediaSecuenciasBetCompleted <- function(seqs) {
  return(round(mean(seqs[seqs[["BetCompleted"]]!=0][["BetCompleted"]]), 2))
}

mediaSecuenciasBetCompleted(secuencias) #2.06
mediasBetCompleted(secuencias) #0.6


####CONCLUSION: 
# Casi el 30% de la muestra son apostadores, frente al casi el 70% que no lo son.
# El numero medio de apuestas entre todos los usuarios es de 0.6, si tenemos solo encuenta 
# los apostantes tenemos un numero medio de 2.06.



# ------------------- 3a. Relacion entre addBet y betCompleted

#                action_node action_node_id
#                     addBet             80
#  AddBetCombForecastElement             81
#AddBetDirectForecastElement             82
#                 addBetHorG             83
#                 addBetLive             84
#           addBetRealMadrid             85
#    AddForecastOrTricastBet             86
#          addFreeBetsTicket             87
#----
#               betCompleted             90
#----

# Numero de personas que añaden apuesta (en total, la completen o no)
num.total.add<-length(which(unlist(lapply(secuencias$Secuencia, 
                                          function(x){(80 %in% x || 81 %in% x || 82 %in% x 
                                                       || 83 %in% x || 84 %in% x || 85 %in% x 
                                                       || 86 %in% x || 87 %in% x)
                                          })))) 
num.total.add # 6518



# Numero de personas que añaden apuesta y la completan
num.add.completed<-length(which(unlist(lapply(secuencias$Secuencia, 
                                              function(x){
                                                90 %in% x && 
                                                  (80 %in% x || 81 %in% x || 82 %in% x 
                                                   || 83 %in% x || 84 %in% x || 85 %in% x 
                                                   || 86 %in% x || 87 %in% x)
                                              })))) 
num.add.completed # 3719

# Por ejemplo:
secuencias[12,]$Secuencia
# ... 84(addBetInLive)  71(AccessToTicket)  96(ChangeAmountTicket) 101(CloseBet) 130(errorMsgTicket) 101(CloseBet) 130(errorMsgTicket) 101(CloseBet) 130(errorMsgTicket) 101(CloseBet)  90(betCompleted) ...




# Numero de personas que añaden apuesta y luego NO completan la apuesta
num.add.non.completed<-length(which(unlist(lapply(secuencias$Secuencia, 
                                                  function(x){
                                                    !(90 %in% x) && 
                                                      (80 %in% x || 81 %in% x || 82 %in% x 
                                                       || 83 %in% x || 84 %in% x || 85 %in% x 
                                                       || 86 %in% x || 87 %in% x)
                                                  })))) 
num.add.non.completed # 2799

# Por ejemplo:
secuencias[3,]$Secuencia
# 187 183 174 285 241 209  80 241 209  80(addBet) 71(AccessToTicket) 96(ChangeAmountTicket) 96(ChangeAmountTicket)


# Numero de personas que completan una apuesta sin haberla abierto:
length(which(unlist(lapply(secuencias$Secuencia, 
                           function(x){
                             90 %in% x && 
                               (!(80 %in% x) && !(81 %in% x) && !(82 %in% x) 
                                && !(83 %in% x) && !(84 %in% x) && !(85 %in% x) 
                                && !(86 %in% x) && !(87 %in% x))
                           })))) #  5
# Por ejemplo:
secuencias[3372,]$Secuencia
# ... 266(SelectSport: soccer) 210(SelectEvent: soccer) 187(loadHomePage)  71(AccessToTicket) 101(CloseBet)  90(betCompleted) 102(ContinueBetting)

secuencias[5288,]$Secuencia
# 187(loadHomePage)  24(AccessFromCarrusel:DirectosPage) 149(Go to: ChangeSportInLivePage) 218(DirectAccessLeague: handball) 149(Go to: ChangeSportInLivePage) 183(goToIndexPage)  28(AccessFromCarrusel:UltimoMinutoPage) 187(loadHomePage)  28(AccessFromCarrusel:UltimoMinutoPage) 247(SelectMarket: rugby)  90(betCompleted)



###CONCLUSION: 
# 1. El hecho de añadir apuesta, no significa que luego esta apuesta sea completada Existen 2799
# sesiones que no completaron sus apuestas. Es decir un 40% no completaron en la misma sesion sus apuestas
num.add.non.completed/num.total.add*100 # 42.94%

# 2. Existen 5 secuencias poco comprensibles que tienen un betCompleted sin haber añadido una apuesta.
# Esta situacion se puede dar aunque no es muy tipica (Solo 5 secuencias): Un usuario ha podido añadir apuestas
# en una sesion y se ha producido un timeout y cuando vuelve al ticket cierra la apuesta y la completa
# Si nos fijamos muchas tienen un evento 71 (AccessToTicket) o 96 (ChangeAmountTicket).

# --------------- FIN 3a. Relacion entre addBet y betCompleted



# ------------------- 3b. Relacion entre CloseBet y betCompleted

#                action_node action_node_id
#               betCompleted             90
#----
#                   CloseBet            101
#----

# Numero total de personas que cierran apuesta (la completen o no)
num.total.closed<-length(which(unlist(lapply(secuencias$Secuencia, 
                                             function(x){
                                               101 %in% x
                                             })))) 
num.total.closed # 4136

# Numero de personas que cierran apuesta y completan apuesta
num.closed.completed<-length(which(unlist(lapply(secuencias$Secuencia, 
                                                 function(x){
                                                   101 %in% x && 90 %in% x
                                                 })))) 
num.closed.completed # 3721

# Por ejemplo:
secuencias[5,]$Secuencia
# ... 252  80(addBet) 71(AccessToTicket) 101(CloseBet)  90(betCompleted) 210 102 252 ...




# Numero de personas que cierran apuesta pero no llegan a completarla
num.closed.non.completed<-length(which(unlist(lapply(secuencias$Secuencia, 
                                                     function(x){
                                                       101 %in% x && !(90 %in% x)
                                                     })))) 
num.closed.non.completed # 415

# Por ejemplo:
secuencias[8,]$Secuencia
# ... 84(addBetLive) 71(AccessToTicket) 101(CloseBet) 130(errormsgTicket)



# Numero de personas que sin cerrar apuesta tienen accion de completarla (NO TIENE SENTIDO)
length(which(unlist(lapply(secuencias$Secuencia, 
                           function(x){
                             !(101 %in% x) && 90 %in% x
                           })))) # 3
# Por ejemplo:
secuencias[5288,]$Secuencia
# 187(loadHomePage)  24(AccessFromCarrusel:DirectosPage) 149(Go to: ChangeSportInLivePage) 218(SelectEventLive: basketball) 149(Go to: ChangeSportInLivePage) 183(goToIndexPage)  28(AccessFromCarrusel:UltimoMinutoPage) 187(loadHomePage)  28(AccessFromCarrusel:UltimoMinutoPage) 247(SelectMarket: basketball)  90(betCompleted)

secuencias[6701,]$Secuencia
# ...84(addBetLive) 187(loadHomePage)  24(AccessFromCarrusel:DirectosPage) 149(Go to: ChangeSportInLivePage) 149(Go to: ChangeSportInLivePage) 174(Go to: OpenSportMenu) 138(Go to: AccessToLastMinute) 252(SelectMarket: soccer)  90(betCompleted)



###CONCLUSION: 
# 1. No todos los usuarios que cierran una apuesta terminan por completarla, aunque si un alto porcentaje:
num.closed.completed/num.total.closed*100 # 89.96

# Existe la posibilidad de que el usuario intente cerrar la apuesta pero el sistema no le deje.
# Muy probablemente por un error de ticket. Vamos a ver de las que no se cerraron cuantas tienen error de ticket:
num.closed.withError<-length(which(unlist(lapply(secuencias$Secuencia, 
                                                 function(x){
                                                   101 %in% x && !(90 %in% x) && 130 %in% x
                                                 })))) 
num.closed.withError/num.closed.non.completed*100 # 43.13%
# Solamente hay un 43.13%, con lo cual no solo es ese el motivo. 
# El otro motivo es que se arrepienten de la apuesta y la cancelan.

# 2. Por otro lado hay 3 secuencias que tienen un betCompleted sin tener CloseBet, no tiene sentido habria que eliminarlas.

# ----------------FIN 3b. Relacion entre CloseBet y betCompleted

# ---------- 3c. RATIOS entre addBet y CloseBet con referencia a su betCOmpleted
betCompleted <- 90
closeBet <- c(101)
addBet <- c(80:87)


# Ahora se va a tener en cuenta la cantidad de addBet que corresponden a cada betCompleted
# Y de la misma forma la cantidad de closeBet que corresponden a cada betCompleted.
# Y se calcularan unos ratios.
#
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
# secuencias$ratio2 <- ratioPrimero_BetCompleted(secuencias$Secuencia, AddBet)
# secuencias$ratio3 <- ratioPrimero_BetCompleted(secuencias$Secuencia, CloseBet)
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
# ratioSecuenciasPrimero_BetCompleted(secuencias, betCompleted)
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
    lista <<-as.list(ratioPrimero_BetCompleted(secs[["Secuencia"]], primero))
    media <- round(mean(unlist(lista), na.rm=TRUE), 2) 
    return(media)
  }  
  else {
    lista <<-as.list(ratioPrimero_BetCompleted(secs[["Secuencia"]], primero))
    media <- round(mean(unlist(lista), na.rm=TRUE), 2)
    return(media)
  }
}


ratioSecuenciasPrimero_BetCompleted(secuencias, addBet) #4.21
ratioSecuenciasPrimero_BetCompleted(secuencias, closeBet) #1.65


#####CONCLUSION: 
# Esto confirma un poco nuestras teorias, viendo los porcentajes anteriores.
# 1 de cada 5 apuestas que se añaden al ticket acaban por completarse.
# Sin embargo la gran mayoria de personas que cierran la apuesta, la completan.



# --------FIN 3c. RATIOS entre addBet y CloseBet con referencia a su betCompleted
# ------------------FIN 3. Analisis porcentajes apuestas:------------------------------



# ----------------------- 4. Analisis apuestas por deporte: ------------------------

columnasDeportes <- c("futbol", "baloncesto", "tenis", "voley", "beisbol", "balonmano",
                      "rugby", "futbolAmericano", "gimnasia", "galgos", "caballos", 
                      "artesMarciales", "boxeo", "dardos", "deportes", "hockey", 
                      "loteria", "politica", "borrado", "deporteAnterior")


# Lista con nombres
listaDeportes <- 
  list(futbol = c(9, 11, 17, 32, 35, 108, 112, 120, 156, 157,
                  160, 210, 214, 216, 223, 227, 232, 238, 
                  252, 266, 273, 286), 
       baloncesto = c(6, 10, 14, 33, 107, 110, 116, 142, 143, 
                      201, 213, 215, 218, 226, 230, 235, 247, 
                      257, 270, 277), 
       tenis = c(12, 21, 36, 113, 121, 180, 211, 224, 228, 242, 
                 253, 267, 287), 
       voley = c(115, 181, 182, 212, 225, 229, 243, 254, 268, 288),
       beisbol = c(146, 200, 246, 256, 276), 
       balonmano = c(111, 118, 144, 145, 205, 220, 231, 236, 
                     249, 261, 281),
       rugby = c(178, 179, 209, 222, 234, 241, 251, 265, 285), 
       futbolAmericano = c(140, 158, 159, 198, 217, 239, 245, 255, 
                           269, 275), 
       gimnasia = c(34, 272), 
       galgos = c(7, 31, 195, 259, 260, 280), 
       caballos = c(161, 168, 196, 262, 282), 
       artesMarciales = c(141, 199),
       boxeo = c(147, 202), 
       dardos = c(117, 150, 151, 203, 278), 
       deportes = c(155, 204, 219, 248, 258, 279), 
       hockey = c(119, 166, 167, 206, 221, 233, 240, 250, 263, 
                  271, 283), 
       loteria = c(170, 171, 207, 264, 284), 
       politica = c(176, 208, 274),
       borrado = c(152, 153),
       deporteAnterior = c(-1))


contadores <- matrix(vector(mode="numeric",
                            length = length(columnasDeportes)), 
                     ncol=length(columnasDeportes))
colnames(contadores) <- columnasDeportes

#
#
# Deporte más apostado / betCompleted
#

# En la variable «contadores» se acumulan los cómputos
contadores <- matrix(vector(mode="numeric",
                            length = length(columnasDeportes)), 
                     ncol=length(columnasDeportes))
colnames(contadores) <- columnasDeportes

#
# Tercer indicador
#
# Deporte más apostado / betCompleted
#

# En la variable «contadores» se acumulan los cómputos
contadores <- matrix(vector(mode="numeric",
                            length = length(columnasDeportes)), 
                     ncol=length(columnasDeportes))
colnames(contadores) <- columnasDeportes

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
# acumuladorDeportes
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
# invisible(acumuladorDeportes(secuencias$Secuencia, listaDeportes)) 
#
# Acumula las primeras 100 secuencias
# invisible(acumuladorDeportes(secuencias$Secuencia[1:100], listaDeportes)) 
#
# Acumula las secuencias 1, 7 y 17
# invisible(acumuladorDeportes(secuencias$Secuencia[c(1,7,17)], listaDeportes)) 
# ---------------------------------------------

acumuladorDeportes <- function(secuencias, listaDep) {
  
  # Aplanamos la lista de deportes. Es útil para hacer búsquedas
  elementos <- unlist(listaDep)
  
  # Iteramos para cada secuencia
  sapply(secuencias, function(sec) {
    
    # Sólo se sigue si hay «betCompleted» en la secuencia
    if(!is.na(match(betCompleted, sec))) {
      
      # Limpiamos secuencia de elementos que no estén en la lista 
      # de deportes
      sec <- sec[which(sapply(sec, function(x) x %in% 
                                unlist(list(elementos, betCompleted))))]
      
      # Se corta la secuencia según el patron definido por betCompleted
      # en tantas subsecuencias como «betCompleted» haya.
      subSecuencias <- patronBetCompleted(sec, betCompleted)
      
      # Iteramos para cada una de las subsecuencias
      sapply(subSecuencias, function(subsec) {
        
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
              contadores[1, deporte] <<- contadores[1, deporte] + 1
              contadores[1,"deporteAnterior"] <<- match(deporte, columnasDeportes)
              
              # Si se trata de un evento de borrado de apuesta
            } else {  
              # Decrementamos el contador del deporte anterior
              deporteAnterior <- columnasDeportes[contadores[[1,"deporteAnterior"]]]
              contadores[1, "deporteAnterior"] <<- contadores[1, "deporteAnterior"] - 1
            }
          }
        })
      })
    }
  })
}



# ---------------------------------------------
# reinicioContadores
#
# Pone a cero los contadores de los deportes
#
# Variables de entrada: Ninguna
#
# Variable de salida: Ninguna
#
# Ejemplo de uso:
#
# reinicioContadores()
# ---------------------------------------------

reinicioContadores <- function () 
  invisible(lapply(1:dim(contadores)[2], function(i) contadores[1,i] <<- 0))


invisible(acumuladorDeportes(secuencias$Secuencia, listaDeportes)) 
contadores

#      futbol baloncesto tenis voley beisbol balonmano rugby futbolAmericano gimnasia galgos caballos
# [1,]  39370      14298  1703   555      61       902    48             282       13   2120     1836
#      artesMarciales boxeo dardos deportes hockey loteria politica borrado deporteAnterior
# [1,]             24    12    109      203   1831      29       18       0               2


#####CONCLUSION: 
# Los deportes mas apostados son en este orden: futbol, baloncesto, tenis balonmano, hockey, galgos, caballos.
# Y luego hay una serie de deportes menos apostados.
# El que se lleva la palma es el futbol con una gran mayoria de las apuestas.




# ------------------ 5. Analisis porcentajes logados/no logados:---------------
# IMP: Un usuario NO logado puede añadir apuesta pero nunca cerrar apuesta y por lo tanto completarla
# solamente pueden cerrar y completar apuesta usuarios logados

# Numero de personas que se logan
num_logados<-length(which(unlist(lapply(secuencias$Secuencia, 
                                        function(x){
                                          189 %in% x
                                        })))) 
num_logados # 4956

# Porcentaje logados:
num_logados/dim(secuencias)[1]*100 #38.73994%

# Numero de personas que NO se logan
num_NO_logados<-length(which(unlist(lapply(secuencias$Secuencia, 
                                           function(x){
                                             !(189 %in% x)
                                           })))) 
num_NO_logados # 7837

# Porcentaje NO logados:
num_NO_logados/dim(secuencias)[1]*100 #61.26%

# Vamos a hacer algunos analisis anteriores sobre el subconjunto de los logados:
secuenciasLogados<-secuencias[which(unlist(lapply(secuencias$Secuencia, 
                                                  function(x){
                                                    189 %in% x
                                                  })))]

# 1. Dispersion de longitudes de logados:

# Longitud media de secuencias
mean(secuencias$Longitud) # 32.69
mean(secuenciasLogados$Longitud) # 43.16
# La longitud media aumenta con respecto al total del 32 al 43 pasos

summary(secuencias$Longitud)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 2.0     7.0    16.0    32.7    40.0   345.0

summary(secuenciasLogados$Longitud)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 2.00   10.00   23.00   43.16   54.00  345.00

par(mfrow = c( 1, 2 )) 
boxplot(secuencias$Longitud, main="Total secuencias")
boxplot(secuenciasLogados$Longitud, main="Secuencias Logadas") 
par(mfrow = c( 1, 1 )) 
# Se ve claramente como es mucho mas frecuente tener secuencias mas largas


# 2. Apuestas por longitud para logados:

grafoMultipleLogados <- list(
  ggplot() + geom_bar(data = secuenciasLogados,
                      aes(x=factor(Grupo),
                          fill=factor(Status)))
  + xlab("Long. navegación")
  + ylab("frec absoluta")
  + scale_fill_discrete("BetCompleted",
                        labels = c("No apuesta", "Apuesta")),
  ggplot() + geom_bar(data = secuenciasLogados,
                      aes(x=factor(Grupo),
                          fill=factor(Status)),
                      position = "fill")
  + xlab("Long. navegación")
  + ylab("proporción")
  + scale_fill_discrete("BetCompleted",
                        labels = c("No apuesta", "Apuesta")))

marrangeGrob(grafoMultipleLogados, nrow=1, ncol = 2, 
             top = "Proporción BetCompleted según longitud navegación")

# Como era de esperar la proporcion de apuestas aumenta en los logados en general 
# en todos los tramos de longitud con respecto al total de secuencias.


# 3. % apuestas para logados

# Numero de apuestas
num_apuestas.logados<-sum(secuenciasLogados[secuenciasLogados$BetCompleted>=1]$BetCompleted)
num_apuestas.logados #4799

# Numero de personas que apuestan
num_apostantes.logados<-length(secuenciasLogados[secuenciasLogados$BetCompleted>=1]$BetCompleted)
num_apostantes.logados #2249

# Media de apuestas por persona:
num_apuestas.logados/num_apostantes.logados #2.13

# Porcentaje apostantes:
num_apostantes.logados/dim(secuenciasLogados)[1]*100 #45.37%

# Numero de personas que NO apuestan
num_no_apostantes.logados<-length(secuenciasLogados[secuenciasLogados$BetCompleted==0]$BetCompleted)
num_no_apostantes.logados #2707

# Porcentaje NO apostantes:
num_no_apostantes.logados/dim(secuenciasLogados)[1]*100 #54.62%

# Como era de esperar el % de apostantes dentro de los logados aumenta hasta un 45%, logico puesto que 
# los no logados no pueden apostar y hemos reducido la muestra.
# De hecho la media de apuestas sigue siendo la mista en torno a un 2%.
# Como conclusion un 45% de los logados apuestan, frente a un 55% que no lo hacen.


# 4. Relacion entre addBet y betCompleted para logados

# Numero de logados que añaden apuesta (en total, la completen o no)
numLogados.total.add<-length(which(unlist(lapply(secuenciasLogados$Secuencia, 
                                                 function(x){(80 %in% x || 81 %in% x || 82 %in% x 
                                                              || 83 %in% x || 84 %in% x || 85 %in% x 
                                                              || 86 %in% x || 87 %in% x)
                                                 })))) 
numLogados.total.add # 2830



# Numero de logados que añaden apuesta y la completan
numLogados.add.completed<-length(which(unlist(lapply(secuenciasLogados$Secuencia, 
                                                     function(x){
                                                       90 %in% x && 
                                                         (80 %in% x || 81 %in% x || 82 %in% x 
                                                          || 83 %in% x || 84 %in% x || 85 %in% x 
                                                          || 86 %in% x || 87 %in% x)
                                                     })))) 
numLogados.add.completed # 2248



# Numero de logados que añaden apuesta y luego NO completan la apuesta
numLogados.add.non.completed<-length(which(unlist(lapply(secuenciasLogados$Secuencia, 
                                                         function(x){
                                                           !(90 %in% x) && 
                                                             (80 %in% x || 81 %in% x || 82 %in% x 
                                                              || 83 %in% x || 84 %in% x || 85 %in% x 
                                                              || 86 %in% x || 87 %in% x)
                                                         })))) 
numLogados.add.non.completed # 582


# Numero de logados que completan una apuesta sin haberla abierto:
length(which(unlist(lapply(secuenciasLogados$Secuencia, 
                           function(x){
                             90 %in% x && 
                               (!(80 %in% x) && !(81 %in% x) && !(82 %in% x) 
                                && !(83 %in% x) && !(84 %in% x) && !(85 %in% x) 
                                && !(86 %in% x) && !(87 %in% x))
                           })))) #  1




# En el caso de logados se reduce muchisimo el numero de personas que añaden apuesta y no la completan
numLogados.add.non.completed/numLogados.total.add*100 # 20.56%

# Del 40% del total de la muestra se reduce al 20%. 
num.add.non.completed/num.total.add*100 # 42.94%
# Aun asi no se puede decir que si se añade apuesta y esta logado
# complete la apuesta.


# 5. Relacion entre CloseBet y betCompleted para logados

# Numero total de logados que cierran apuesta (la completen o no)
numLogados.total.closed<-length(which(unlist(lapply(secuenciasLogados$Secuencia, 
                                                    function(x){
                                                      101 %in% x
                                                    })))) 
numLogados.total.closed # 2424

# Numero de logados que cierran apuesta y completan apuesta
numLogados.closed.completed<-length(which(unlist(lapply(secuenciasLogados$Secuencia, 
                                                        function(x){
                                                          101 %in% x && 90 %in% x
                                                        })))) 
numLogados.closed.completed # 2247


# Numero de logados que cierran apuesta pero no llegan a completarla
numLogados.closed.non.completed<-length(which(unlist(lapply(secuenciasLogados$Secuencia, 
                                                            function(x){
                                                              101 %in% x && !(90 %in% x)
                                                            })))) 
numLogados.closed.non.completed # 177


# Numero de logados que sin cerrar apuesta tienen accion de completarla (NO TIENE SENTIDO)
length(which(unlist(lapply(secuenciasLogados$Secuencia, 
                           function(x){
                             !(101 %in% x) && 90 %in% x
                           })))) # 2

# Entre los logados si se puede decir practicamente que si cierran apuesta la completan:
numLogados.closed.completed/numLogados.total.closed*100 # 92.69


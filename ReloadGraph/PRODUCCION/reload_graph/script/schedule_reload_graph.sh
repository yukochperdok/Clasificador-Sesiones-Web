#!/bin/bash

# TODO: no declarar la variable a ivel de scriptººº:w
JAVA_HOME='/usr/lib/jvm/java-8-oracle'

echo "CONFIGURACION DE VARIABLES"
DIR_HOME=/home/cronodata/reload_graph

## Ejecutamos el fichero de variables de entorno
. $DIR_HOME/script/set_env_reload_graph.bash

##Directorio del jar   
DIR_JAR=$DIR_HOME/bin/

##Nombre del jar
JAR_NAME=reload_graph.jar

##Directorio del fichero de configuracion   
DIR_CONFIG=$DIR_HOME/config/

## DIR LOG
SCH_LOGFILE=$DIR_HOME/logs/schedule_reload_$(date +%Y%m%d%H%M%S).log

##Directorio de librerias   
DIR_LIB=$DIR_HOME/lib
PATH_LIB=$DIR_LIB/log4j-api-2.7.jar:$DIR_LIB/log4j-core-2.7.jar:$DIR_LIB/neo4j-java-driver-1.0.6.jar:$DIR_LIB/sqljdbc4.2-4.2.jar

echo "Inicido de script "$(date +%Y%m%d%H%M%S) >> $SCH_LOGFILE


OP=$1
OP=${OP:-'reload_graph'}
 
echo "Opcion elegida: $OP" >> $SCH_LOGFILE

$JAVA_HOME/bin/java -cp $DIR_JAR/$JAR_NAME:$PATH_LIB -DDIR_CONFIG=$DIR_CONFIG com.cronodata.ReloadGraph $OP >> $SCH_LOGFILE 2>&1
RET=$?

echo "Acaba la carga con $RET" >> $SCH_LOGFILE

echo "Fin de script "$(date +%Y%m%d%H%M%S) >> $SCH_LOGFILE


exit $RET


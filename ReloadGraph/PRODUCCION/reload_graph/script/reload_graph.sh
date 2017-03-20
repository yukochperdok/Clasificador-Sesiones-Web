#!/bin/bash

echo "CONFIGURACION DE VARIABLES"
DIR_HOME=/home/cronodata/reload_graph

## Ejecutamos el fichero de variables de entorno
source ./set_env_reload_graph.bash
echo "Dir.logs : $RELOAD_GRAPH_OUT_LOGS"

##Directorio del jar   
DIR_JAR=$DIR_HOME/bin/
echo "Dir.jar : $DIR_JAR"

##Nombre del jar
JAR_NAME=reload_graph.jar
echo "Nombre jar : $JAR_NAME"

##Directorio del fichero de configuracion   
DIR_CONFIG=$DIR_HOME/config/
echo "Dir.config : $DIR_CONFIG"

##Directorio de librerias   
DIR_LIB=$DIR_HOME/lib
echo "Dir.lib : $DIR_LIB"
PATH_LIB=$DIR_LIB/log4j-api-2.7.jar:$DIR_LIB/log4j-core-2.7.jar:$DIR_LIB/neo4j-java-driver-1.0.6.jar:$DIR_LIB/sqljdbc4.2-4.2.jar
echo "path librerias : $PATH_LIB"


# Muestra el menu general
_menu()
{
    echo "Selecciona una opcion:"
    echo
    echo "1) Cargar Grafo"
    echo "2) Testear Conexion BBDD"
    echo "3) Borrar Grafo"
    echo
    echo "4) Salir"
    echo
    echo -n "Indica una opcion: "
}

# Muestra la opcion seleccionada del menu
_mostrarResultado()
{
    clear
    echo ""
    echo "------------------------------------"
    echo "Has seleccionado la opcion $1"
    echo "------------------------------------"
    echo ""
}

_ejecucion_java()
{
    ##nohup $JAVA_HOME/bin/java -jar $DIR_JAR/$JAR_NAME -DDIR_CONFIG=$DIR_CONFIG com.cronodata.ReloadGraph $OP &
	echo "Ejecutando nohup $JAVA_HOME/bin/java -cp $DIR_JAR/$JAR_NAME:$PATH_LIB -DDIR_CONFIG=$DIR_CONFIG com.cronodata.ReloadGraph $OP &"
	nohup $JAVA_HOME/bin/java -cp $DIR_JAR/$JAR_NAME:$PATH_LIB -DDIR_CONFIG=$DIR_CONFIG com.cronodata.ReloadGraph $OP &
}

echo "EJECUCION PROGRAMA"
if [ -z "$1" ] ; then

        # opcion por defecto
		opc="0"
 
		# bucle mientas la opcion indicada sea diferente de 9 (salir)
		until [ "$opc" -eq "9" ];
		do
		    case $opc in
		        1)
		            _mostrarResultado $opc
		            _menu
		            OP=reload_graph
		            _ejecucion_java
		            ;;
		        2)
		            _mostrarResultado $opc
		            _menu
		            OP=test_bbdd
		            _ejecucion_java
		            ;;
		        3)
		            _mostrarResultado $opc
		            _menu
		            OP=delete_graph
		            _ejecucion_java
		            ;;
		        4)
		            _mostrarResultado $opc
		            _menu
		            exit 0
		            ;;		       
		        *)
		            # Esta opcion se ejecuta si no es ninguna de las anteriores
		            clear
		            _menu
		            ;;
		    esac
		    read opc
		done
else
	## Operacion a realizar
	OP=$1
	echo "Operacion : $OP"
   	_ejecucion_java
fi


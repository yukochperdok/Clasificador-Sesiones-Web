#!/bin/bash

echo "EJECUCION PROGRAMA"
if [ -z "$1" ] ; then
	echo "Uso incorrecto. Incluir operacion."
	exit -1
else
	case $1 in
		1)
			spark-shell --conf spark.neo4j.bolt.password=cronodata --packages neo4j-contrib:neo4j-spark-connector:1.0.0-RC1,graphframes:graphframes:0.1.0-spark1.6 -i count_nodes.scala 
			;;
		2)
			spark-shell --conf spark.neo4j.bolt.password=cronodata --packages neo4j-contrib:neo4j-spark-connector:1.0.0-RC1,graphframes:graphframes:0.1.0-spark1.6 -i page_rank.scala 
			;;
		3)
			spark-shell --conf spark.neo4j.bolt.password=cronodata --packages neo4j-contrib:neo4j-spark-connector:1.0.0-RC1,graphframes:graphframes:0.1.0-spark1.6 -i connected_components.scala 
			;;
		4)
			spark-shell --conf spark.neo4j.bolt.password=cronodata --packages neo4j-contrib:neo4j-spark-connector:1.0.0-RC1,graphframes:graphframes:0.1.0-spark1.6 -i strongly_connected_components.scala
			;;
		*) 
			echo "Opcion Incorrecta"
			exit 0 
			;;
	esac

fi

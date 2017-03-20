import org.neo4j.spark._
import org.apache.spark.graphx._
import org.apache.spark.graphx.lib._


val graphQuery = "MATCH (n:ACTION)-[r]->(m:ACTION) RETURN id(n) as source, id(m) as target, type(r) as value"
val graph = Neo4jGraph.loadGraphFromNodePairs(sc, graphQuery)

val graphComunidades = graph.connectedComponents()     
graphComunidades.vertices.collect

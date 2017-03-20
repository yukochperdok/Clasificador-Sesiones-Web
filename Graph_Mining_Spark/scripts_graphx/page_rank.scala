import org.neo4j.spark._
import org.apache.spark.graphx._
import org.apache.spark.graphx.lib._


val graphQuery = "MATCH (n:ACTION)-[r]->(m:ACTION) RETURN id(n) as source, id(m) as target, type(r) as value"
val graph = Neo4jGraph.loadGraphFromNodePairs(sc, graphQuery)

graph.vertices.count
graph.edges.count 

val graphPageRank = PageRank.run(graph, numIter = 5)
val verticesRank = graphPageRank.vertices.take(5)

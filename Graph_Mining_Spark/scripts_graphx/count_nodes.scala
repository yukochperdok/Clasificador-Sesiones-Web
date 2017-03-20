
import org.neo4j.spark._

val query = "MATCH (n) return n"
Neo4jRowRDD(sc, query).count

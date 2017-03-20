require(igraph)
require(visNetwork)
require(RNeo4j)

rm(list = ls())

max_num_edges <- 100

getListColours_HEX <- function(num.colores) {
    colores.hex <- c()
    colores <- col2rgb(sample(colors(distinct = TRUE), num.colores))
    for (col in c(1:dim(colores)[2]))
        colores.hex <- c(colores.hex, rgb(colores["red", col], colores["green", col], colores["blue", col], maxColorValue = 255))

    # colores.hex <- c("#FFC200","#FF6400","#FF1200","#FF0098","#005C55",
    #                  "#FD625E","#9300FF","#005C55","#00FFF3","#00FF81",
    #                  "#B4FF00","#00FF33","#FFC477","#E2A2FF","#8C6EFF",
    #                  "#FFC200","#FF6400","#FF1200","#FF0098","#005C55",
    #                  "#FD625E","#9300FF","#005C55","#00FFF3","#00FF81",
    #                  "#B4FF00","#00FF33","#FFC477","#E2A2FF","#8C6EFF",
    #                  "#FFC200","#FF6400","#FF1200","#FF0098")
    return(colores.hex)
}


# Conexion al grafo
graph = startGraph(url = "http://neo4j-virtual-machine.northeurope.cloudapp.azure.com:80/db/data/", username = "neo4j", password = "cronodata")

# Recogida de relaciones acumulando por peso
query = "MATCH (n:ACTION)-[r]->(m:ACTION) RETURN n.id as from, m.id as to, count(r) as weight"
edges = cypher(graph, query)

# 1. Calculamos alguna metricas de todo el grafo
# Creamos un grafo difigido
ig = graph_from_data_frame(edges, directed = T)

#average_length <- average.path.length(ig,directed = T)
mean_distance <- mean_distance(ig, directed = T)
mean_degree <- mean(degree(ig))

shortest.paths.addBet <- shortest.paths(ig, v = V(ig), to = V(ig), weights = NA)[, "addBet"]
shortest.paths.betCompleted <- shortest.paths(ig, v = V(ig), to = V(ig), weights = NA)[, "betCompleted"]

mean_shortest_addBet <- mean(shortest.paths.addBet[is.finite(shortest.paths.addBet)])
mean_shortest_betCompleted <- mean(shortest.paths.betCompleted[is.finite(shortest.paths.addBet)])

measures <- data.frame(mean_distance, mean_degree, mean_shortest_addBet, mean_shortest_betCompleted)


# 2. Vamos a quitar nodos extraños:
edges <- edges[ - c(which(edges$from == "not_specified"), which(edges$to == "not_specified")),]
edges <- edges[ - c(grep("UNKNOWN", edges$from), grep("UNKNOWN", edges$to)),]
edges <- edges[ - c(grep("#", edges$from), grep("#", edges$to)),]


# Vamos a quedarnos solo con las transiciones importantes, con mas peso.
# Y asi nos quitamos eventos concretos y nodos que no tengan importancia
edges <- edges[order( - edges$weight),][1:max_num_edges,]


# Creamos los nodos a partir de las aristas
nodes = data.frame(id = unique(c(edges$from, edges$to)))
nodes$label = nodes$id

# Volvemos a crear el grafo solo con las aristas limpias
ig = graph_from_data_frame(edges, directed = T)


# 3. Calculamos el pageRank de los nodos:
nodes$page_rank <- page.rank(ig, directed = T)$vector


# 4. PRIMERA CLUSTERIZACION: por componentes conectados
# Clusterizamos strongly connected components 
# - Deteccion de componentes de la navegacion por lo fuertemente conectados que estan 
comunidad.base.navegacion = components(ig, mode = "strong")
nodes$group_strongly = comunidad.base.navegacion$membership
nodes$col_group_strongly = getListColours_HEX(comunidad.base.navegacion$no)[comunidad.base.navegacion$membership]

# Calculamos tamaño de nodo en funcion a su medida de lo intermedio que este
nodes$betweenness = betweenness(ig, weights = E(ig)$weight) + 1
nodes$size_betweenness <- ifelse(nodes$betweenness > 3, nodes$betweenness / 10, nodes$betweenness)
# nodes$size_betweenness <- ifelse(nodes$betweenness<10 & nodes$betweenness>0,1,
#                                  ifelse(nodes$betweenness<70,2,
#                                         ifelse(nodes$betweenness<150,3,
#                                                ifelse(nodes$betweenness<250,4,
#                                                       ifelse(nodes$betweenness<350,5,6)))))

# 5. SEGUNDA CLUSTERIZACION: por comunidades
# Calculamos comunidades con ramdom walks
clusters.random_walks = cluster_walktrap(ig, weights = E(ig)$weight)
nodes$group_comunities = clusters.random_walks$membership
nodes$col_group_comunities = getListColours_HEX(length(unique(clusters.random_walks$membership)))[clusters.random_walks$membership]

nodes$modularity = clusters.random_walks$modularity
nodes$size_comunities = abs(clusters.random_walks$modularity * 50)

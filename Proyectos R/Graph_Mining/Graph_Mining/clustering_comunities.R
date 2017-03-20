rm(list = ls())
setwd("D:/Pedro/Master MBIT/Proyecto Master/PROYECTO CODERE/Exploracion Datos/Data Mining/RNeo4j")
ficheros <- list.files()

is.installed <- function(paquete) is.element(
  paquete, installed.packages())

if (!is.installed("igraph"))
    install.packages("igraph")
if (!is.installed("visNetwork"))
    install.packages("visNetwork")
if (!is.installed("RNeo4j"))
    install.packages("RNeo4j")

require(igraph)
require(visNetwork)
require(RNeo4j)


############# TEMPORAL CARGA GRAFO:
#load("grafo.RData")
##################################

# Conexion al grafo
graph = startGraph(url="http://neo4j-virtual-machine.northeurope.cloudapp.azure.com:80/db/data/", username = "neo4j", password = "cronodata")

# Recogida de relaciones acumulando por peso
query = "MATCH (n:ACTION)-[r]->(m:ACTION) RETURN n.id as from, m.id as to, count(r) as weight"
edges = cypher(graph, query)
head(edges)
dim(edges)[1]


# Calculamos los nodos
nodes = data.frame(id=unique(c(edges$from, edges$to)))
nodes$label = nodes$id
head(nodes)
dim(nodes)[1]

# Visualizamos grafo cargado:
visNetwork(nodes, edges)

# Cargamos un igraph
ig = graph_from_data_frame(edges, directed=T)
ig
head(ig)
E(ig)
E(ig)$weight


##### TEMPORAL GUARDAMOS GRAFO
#save.image("grafo.RData")
#############################


######### PRUEBA 1: Algunas medidas y clusteres sin flitrar#############

#### Medida strongly connected components

# Creamos un nuevo valor en los nodos que sea el valor de su tamaño
# en funcion a lo intermedio que esta en los caminos (betweenness)
nodes$value = betweenness(ig, weights = E(ig)$weight)
head(nodes)

# Lo visualizamos
visNetwork(nodes, edges)
# OBS: Tal vez deberiamos quitar las autotransiciones

# Vamos a generar cluster en funcion a esta medida de betweenness:
clusters = cluster_edge_betweenness(ig, weights = E(ig)$weight)
length(clusters)
clusters[1:2]
# Practicamente nos salen los mismos clusters que nodos

# Asociamos cada nodo a un grupo (su identificador de cluster)
nodes$group = clusters$membership
head(nodes)

visNetwork(nodes, edges)


#### Medida strongly connected components 

# Clusterizamos ahora por componentes mas o menos conectados: strongly connected components
clusters2 = components(ig, mode = "strong")
length(clusters2)
clusters2[1:2]

# Asociamos cada nodo a un grupo (su identificador de cluster)
nodes$group = clusters2$membership
head(nodes)

visNetwork(nodes, edges)

# CONCLUSION: Aparecen muchisimos nodos y es complicado de ver las comunidades
##############################################################################
##############################################################################

######### PRUEBA 2: Filtramos por pesos: Conected Components#############
# 1º Vamos a quitar nodos extraños:
edges.limpios <- edges[ - c(which(edges$from == "not_specified"), which(edges$to == "not_specified")),]
edges.limpios <- edges.limpios[ - c(grep("UNKNOWN", edges.limpios$from), grep("UNKNOWN", edges.limpios$to)),]

# 2º Vamos a revisar sus pesos
mean(edges.limpios$weight)
summary(edges.limpios$weight)
boxplot(edges.limpios$weight)
# Se ve que tenemos muchisimos de pesos bajos

dim(edges.limpios[edges.limpios$weight > 37,])[1] # 1059
dim(edges.limpios[edges.limpios$weight < 37,])[1] # 12605

dim(edges.limpios[edges.limpios$to == edges.limpios$from,])[1] # 367 autoedges
autoedges <- edges.limpios[edges.limpios$to == edges.limpios$from,]
autoedges[order( - autoedges$weight),][1:100,]
# Todos son nodos de comportamiento, no de eventos por ello los vamos a dejar en principio

# Vamos a quedarnos solo con las transiciones importantes, con mas peso.
# Y asi nos quitamos eventos concretos y nodos que no tengan importancia
edges.filtrado.pesos <- edges.limpios[order( - edges.limpios$weight),][1:100,]
head(edges.filtrado.pesos)
dim(edges.filtrado.pesos)[1]

nodes.filtrado.pesos = data.frame(id = unique(c(edges.filtrado.pesos$from, edges.filtrado.pesos$to)))
nodes.filtrado.pesos$label = nodes.filtrado.pesos$id
head(nodes.filtrado.pesos)
dim(nodes.filtrado.pesos)[1] # Tenemos 55 nodos

# Visualizamos grafo cargado:
visNetwork(nodes.filtrado.pesos, edges.filtrado.pesos)

# Cargamos un igraph
ig.filtrado.pesos = graph_from_data_frame(edges.filtrado.pesos, directed = T)
ig.filtrado.pesos
head(ig.filtrado.pesos)
E(ig.filtrado.pesos)
E(ig.filtrado.pesos)$weight

# Clusterizamos ahora por componentes mas o menos conectados: 
# 1.weakly connected components - Deteccion de comunidades aisladas
comunidades_aisladas = components(ig.filtrado.pesos, mode = "weak")
comunidades_aisladas$no # Se han obtenido 6 clusters


# Asociamos cada nodo a un grupo (su identificador de cluster)
nodes.filtrado.pesos$group = comunidades_aisladas$membership
head(nodes.filtrado.pesos)

visNetwork(nodes.filtrado.pesos, edges.filtrado.pesos)


# 2. strongly connected components - Deteccion de base de la navegacion
comunidad.base.navegacion = components(ig.filtrado.pesos, mode = "strong")
comunidad.base.navegacion$no # Se han obtenido 34 clusters


# Asociamos cada nodo a un grupo (su identificador de cluster)
nodes.filtrado.pesos$group = comunidad.base.navegacion$membership
head(nodes.filtrado.pesos)

visNetwork(nodes.filtrado.pesos, edges.filtrado.pesos)

# Vamos a caracterizar mejor la visualizacion:

edges.filtrado.pesos$width <- 1 + edges.filtrado.pesos$weight / 500
#edges.filtrado.pesos$color <- "gray"    # line color  
#edges.filtrado.pesos$arrows <- "to" # arrows: 'from', 'to', or 'middle'
#edges.filtrado.pesos$smooth <- TRUE    # should the edges be curved?
edges.filtrado.pesos$shadow <- TRUE # edge shadow

nodes.filtrado.pesos$shape <- "dot"
nodes.filtrado.pesos$shadow <- TRUE # Nodes will drop shadow
#nodes$title <- nodes$media # Text on click
#nodes$label <- nodes$type.label # Node label
nodes.filtrado.pesos$size = betweenness(ig.filtrado.pesos, weights = E(ig.filtrado.pesos)$weight) + 1
nodes.filtrado.pesos$size <- ifelse(nodes.filtrado.pesos$size > 3, nodes.filtrado.pesos$size / 10, nodes.filtrado.pesos$size)
#nodes.filtrado.pesos$borderWidth <- 2 # Node border width

visNetwork(nodes.filtrado.pesos, edges.filtrado.pesos, width = "100%", height = "900px", main = "Network!")


######### PRUEBA 3: Filtramos por pesos: Short Random Walks#############
edges.filtrado.pesos <- edges.limpios[order( - edges.limpios$weight),][1:100,]
head(edges.filtrado.pesos)
dim(edges.filtrado.pesos)[1]

nodes.filtrado.pesos = data.frame(id = unique(c(edges.filtrado.pesos$from, edges.filtrado.pesos$to)))
nodes.filtrado.pesos$label = nodes.filtrado.pesos$id
head(nodes.filtrado.pesos)
dim(nodes.filtrado.pesos)[1] # Tenemos 55 nodos

# Cargamos un igraph
ig.filtrado.pesos = graph_from_data_frame(edges.filtrado.pesos, directed = T)
ig.filtrado.pesos
head(ig.filtrado.pesos)
E(ig.filtrado.pesos)
E(ig.filtrado.pesos)$weight


clusters.random_walks = cluster_walktrap(ig.filtrado.pesos, weights = E(ig)$weight)
nodes.filtrado.pesos$group = clusters.random_walks$membership
nodes.filtrado.pesos$size = abs(clusters.random_walks$modularity * 100)
head(nodes.filtrado.pesos)

visNetwork(nodes.filtrado.pesos, edges.filtrado.pesos, width = "100%", height = "900px", main = "Network!")
#network <- visNetwork(nodes.filtrado.pesos, edges.filtrado.pesos, width="100%", height="900px", main="Network!")
#visSave(network, file = "network.html")

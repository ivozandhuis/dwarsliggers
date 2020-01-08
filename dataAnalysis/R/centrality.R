setwd("~/git/dwarsliggers/")
source("dataTransformation/R/constructGraphs.R")

g <- tot_grp

A <- as_adjacency_matrix(g)
biggest_eigenvalue <- max(eigen(A)$values)
kappa <- 1/biggest_eigenvalue

V(g)$degree         <- igraph::degree(g)
V(g)$betweenness    <- igraph::betweenness(g)
V(g)$closeness      <- igraph::closeness(g)
V(g)$eigen          <- igraph::eigen_centrality(g)$vector
V(g)$powerkappa     <- igraph::power_centrality(g, exponent = kappa) 
V(g)$powerhalfkappa <- igraph::power_centrality(g, exponent = 0.5*kappa) 
V(g)$powerzero      <- igraph::power_centrality(g, exponent = 0) 


g_df<- data.frame(my_medewerkersnummer = as.integer(V(g)$name), 
                  naam = V(g)$achternaam.x, 
                  staker = V(g)$staker, 
                  
                  degree      = as.double(V(g)$degree),
                  betweenness = as.double(V(g)$betweenness),
                  closeness   = as.double(V(g)$closeness),
                  eigen       = as.double(V(g)$eigen),
                  
                  powerhalfkappa = as.double(V(g)$powerhalfkappa),
                  powerkappa = as.double(V(g)$powerkappa),
                  powerzero = as.double(V(g)$powerzero)
                  
)

g_edgelist <- as.data.frame(get.edgelist(g))
write.table(g_df, "data/constructs/csv/g_nodelist.csv", sep = ",", row.names=FALSE)
write.table(g_edgelist, "data/constructs/csv/g_edgelist.csv", sep = ",", row.names=FALSE)



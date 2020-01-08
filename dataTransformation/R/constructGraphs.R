setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")
source("dataTransformation/R/constructNeighbourgraph.R")
source("dataTransformation/R/constructFamilygraph.R")
source("dataTransformation/R/constructOrganisationgraph.R")

g <- union(fam_grp, org_grp, nbr_grp)

# remove double vertex-attributes
edges <- as.data.frame(get.edgelist(g))
g <- graph_from_data_frame(edges, directed = FALSE, vertices = df)
rm(edges)

# add centrality-measures in totalgraph
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

gexf <- igraph.to.gexf(g) # duurt lang!!
print(gexf, "data/constructs/gexf/totalgraph.gexf", replace=T) 
tot_grp <- g

rm(biggest_eigenvalue)
rm(A)
rm(g)
rm(gexf)

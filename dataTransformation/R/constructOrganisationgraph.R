setwd("~/git/dwarsliggers/")

setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

library(igraph)
library(rgexf) # to write a gexf file (=Gephi) from igraph object

jaarboekje <- read.csv("data/sources/csv/jaarboekje.csv")

# create edgelist for bipartite graph: edges between medewerker and organisation
selection <- c("my_medewerkersnummer", "my_organisatienummer")
org_edges  <- jaarboekje[selection]
rm(selection)
rm(jaarboekje)

# select RPs
my_medewerkersnummers <- c(df$my_medewerkersnummer)
org_edges <- org_edges[org_edges$my_medewerkersnummer %in% my_medewerkersnummers,]

# create igraph object; first bipartite, then projection on medewerkers
org_tmp <- graph_from_data_frame(org_edges)
V(org_tmp)$type <- V(org_tmp)$name %in% org_edges[,1]
org_edges <- as_edgelist(bipartite.projection(org_tmp)$proj2)
rm(org_tmp)

# create igraph object
org_grp <- graph_from_data_frame(org_edges, directed = FALSE, vertices = df)
rm(org_edges)

# create gexf-file in order to import it into Gephi
gexf <- igraph.to.gexf(org_grp) # duurt lang!!
print(gexf, "data/constructs/gexf/organisationgraph.gexf", replace=T) 
rm(gexf)

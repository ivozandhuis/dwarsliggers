# input:  df and family edgelist between RP's (familynetwork_edgelist.csv)
# output: (1) igraph object grp containing available RP's as nodes, their attributes and family-relations
#         (2) statnet object net containing available RP's as nodes, their attributes and family-relations

setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

library(igraph)
library(rgexf) # to write a gexf file (=Gephi) from igraph object

fam_edges <- read.csv("data/constructs/csv/familynetwork_edgelist.csv")

# select only complete observations
my_medewerkersnummers <- c(df$my_medewerkersnummer)
fam_edges <- fam_edges[fam_edges$target %in% my_medewerkersnummers,]
fam_edges <- fam_edges[fam_edges$source %in% my_medewerkersnummers,]

# create igraph object
fam_grp <- graph_from_data_frame(fam_edges, directed = TRUE, vertices = df)


fam_grp <- as.undirected(fam_grp)
simplify(fam_grp)

rm(fam_edges)

# create gexf-file in order to import it into Gephi
gexf <- igraph.to.gexf(fam_grp) # duurt lang!!
print(gexf, "data/constructs/gexf/familygraph.gexf", replace=T) 
rm(gexf)

# input:  df and geographical distance between RP's (distance.csv)
# output: (1) igraph object nbr_grp containing available RP's as nodes, their attributes and neighbour-relations
#         (2) statnet object nbr_net containing available RP's as nodes, their attributes and neighbour-relations
#         (3) extended df with data on neighbours

setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

library(igraph)
library(rgexf) # to write a gexf file (=Gephi) from igraph object

# read distances
distance <- read.csv("data/constructs/csv/distance.csv")

# filter medewerkers without geo-location
df_filtered <- df[!(is.na(df$len)),]
my_medewerkersnummers <- c(df_filtered$my_medewerkersnummer)
distance <- distance[distance$medewerkera %in% my_medewerkersnummers,]
distance <- distance[distance$medewerkerb %in% my_medewerkersnummers,]

# create edgelist; we define neighbours people within 10 meters geodesic distance 
nbr_edges <- distance
nbr_edges <- nbr_edges[nbr_edges$distance < 10,]
rm(distance)

nbr_edges <- merge(nbr_edges, df_filtered, by.x = "medewerkera", by.y = "my_medewerkersnummer")
nbr_edges <- merge(nbr_edges, df_filtered, by.x = "medewerkerb", by.y = "my_medewerkersnummer")

nbr_edges$diff_leeftijd <- abs(nbr_edges$leeftijd.x - nbr_edges$leeftijd.y)
nbr_edges$both_strikers <- nbr_edges$staker.x && nbr_edges$staker.y

nbr_edges <- nbr_edges[c("medewerkera"
                         ,"medewerkerb"
                         ,"distance"
                         ,"diff_leeftijd"
                         ,"both_strikers"
)]

# create igraph object
nbr_grp <- graph_from_data_frame(nbr_edges, directed = FALSE, vertices = df_filtered)
rm(nbr_edges)

# add vertex attributes
#al <- get.adjlist(nbr_grp)
#att <- V(nbr_grp)$kleur
#V(nbr_grp)$aantalburen          <- sapply(al, function(x) length(att[x]))
#V(nbr_grp)$aantalstakendeburen  <- sapply(al, function(x) length(which(att[x] != 'b')))
#V(nbr_grp)$aantalopgevendeburen <- sapply(al, function(x) length(which(att[x] == 'w')))
#rm(att)
#rm(al)

# add neighborhood
cfg <- cluster_fast_greedy(nbr_grp)
V(nbr_grp)$neighbourhood <- cfg$membership
rm(cfg)

# create gexf-file in order to import it into Gephi
gexf <- igraph.to.gexf(nbr_grp) # duurt lang!!
print(gexf, "data/constructs/gexf/neighbourgraph.gexf", replace=T) 
rm(gexf)
rm(df_filtered)

# to be used by script that needs statnet-object
# create statnet object; equivalent to grp
#library(statnet)
#library(intergraph) # to convert from igraph object to statnet-object
#nbr_net <- asNetwork(nbr_grp)


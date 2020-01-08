# input:  df and geographical distance between RP's (distance.csv)
# output: (1) igraph object grp containing available RP's as nodes, their attributes and neighbour-relations
#         (2) statnet object net containing available RP's as nodes, their attributes and neighbour-relations
#         (3) extended df with data on neighbours

setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

library(igraph)
library(statnet)
library(intergraph) # to convert from igraph object to statnet-object
library(rgexf) # to write a gexf file (=Gephi) from igraph object

distance <- read.csv("data/constructs/csv/distance.csv")

# select only complete observations
df_klein <- subset(df, select = c(my_medewerkersnummer, kleur))

distance <- merge(distance, df_klein, by.x = "medewerkera", by.y = "my_medewerkersnummer")
distance <- merge(distance, df_klein, by.x = "medewerkerb", by.y = "my_medewerkersnummer")

rm(df_klein)

# create igraph object; we define neighbours people within 50 meters geodesic distance 
grp <- graph_from_data_frame(distance[distance$distance < 50,], directed = FALSE, vertices = df)
rm(distance)

# add graph attributes
al <- get.adjlist(grp)
att <- V(grp)$kleur
V(grp)$aantalburen          <- sapply(al, function(x) length(att[x]))
V(grp)$aantalstakendeburen  <- sapply(al, function(x) length(which(att[x] != 'b')))
V(grp)$aantalopgevendeburen <- sapply(al, function(x) length(which(att[x] == 'w')))
rm(att)
rm(al)

cfg <- cluster_fast_greedy(grp)
V(grp)$neighborhood <- cfg$membership
rm(cfg)

# create gexf-file in order to import it into Gephi
# gexf <- igraph.to.gexf(grp) # duurt lang!!
# print(gexf, "data/constructs/gexf/neighbourgraph.gexf", replace=T) 

# create statnet object; equivalent to grp
net <- asNetwork(grp)

# extend df
df2 <- data.frame(V(grp)$name, 
                  V(grp)$aantalburen, 
                  V(grp)$aantalstakendeburen, 
                  V(grp)$aantalopgevendeburen,
                  V(grp)$neighborhood
                  )

df <- merge(df, df2, by.x = "my_medewerkersnummer", by.y = "V.grp..name")
rm(df2)

df$V.grp..neighborhood <- as.factor(df$V.grp..neighborhood)

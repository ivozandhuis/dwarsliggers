setwd("~/git/dwarsliggers/")
source("dataTransformation/R/constructNeighbourgraph1.R")
source("dataTransformation/R/constructNeighbourgraph2.R")

# extend df
df$neighbourhood1        <- as.factor(V(nbr1_grp)$neighbourhood)
df$aantalburen1          <- V(nbr1_grp)$aantalburen
df$aantalstakendeburen1  <- V(nbr1_grp)$aantalstakendeburen
df$aantalopgevendeburen1 <- V(nbr1_grp)$aantalopgevendeburen

df$neighbourhood2        <- as.factor(V(nbr2_grp)$neighbourhood)
df$aantalburen2          <- V(nbr2_grp)$aantalburen
df$aantalstakendeburen2  <- V(nbr2_grp)$aantalstakendeburen
df$aantalopgevendeburen2 <- V(nbr2_grp)$aantalopgevendeburen

# extend graphs
V(nbr1_grp)$neighbourhood2        <- df$neighbourhood2
V(nbr1_grp)$aantalburen2          <- df$aantalburen2
V(nbr1_grp)$aantalstakendeburen2  <- df$aantalstakendeburen2
V(nbr1_grp)$aantalopgevendeburen2 <- df$aantalopgevendeburen2

V(nbr2_grp)$neighbourhood1        <- df$neighbourhood1
V(nbr2_grp)$aantalburen1          <- df$aantalburen1
V(nbr2_grp)$aantalstakendeburen1  <- df$aantalstakendeburen1
V(nbr2_grp)$aantalopgevendeburen1 <- df$aantalopgevendeburen1

# create new gexf-file in order to import it into Gephi
gexf <- igraph.to.gexf(nbr1_grp) # duurt lang!!
print(gexf, "data/constructs/gexf/neighbourgraph1.gexf", replace=T) 
rm(gexf)

# create new gexf-file in order to import it into Gephi
gexf <- igraph.to.gexf(nbr2_grp) # duurt lang!!
print(gexf, "data/constructs/gexf/neighbourgraph2.gexf", replace=T) 
rm(gexf)

# write
write.table(df, "data/constructs/csv/total.csv", sep = ",", row.names=FALSE)


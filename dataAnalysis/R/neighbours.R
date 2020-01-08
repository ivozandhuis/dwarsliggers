# analyse neighbours graphs

setwd("~/git/dwarsliggers/")
source("dataTransformation/R/constructNeighbourgraph.R")

library(statnet)
library(intergraph) # to convert from igraph object to statnet-object

# filter medewerkers without geo-location
toAnalyze <- df
toAnalyze <- toAnalyze[!(is.na(toAnalyze$len)),]

# remove unused levels in afdeling_kohier
toAnalyze <- droplevels(toAnalyze)

# basic data nbr_grp
toAnalyze$nbr_degree      <- igraph::degree(nbr_grp)
toAnalyze$nbr_betweenness <- igraph::betweenness(nbr_grp)

toAnalyze[toAnalyze$nbr_degree > 3,]$nbr_degree <- 10000

cross <- table(toAnalyze$nbr_degree, toAnalyze$staker)
cross_rel <- prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2

aantalstakers_rel <- as.numeric(cross_rel[,2])
aantalburen <- c(0,1,2,3,4)
cor.test(aantalburen, aantalstakers_rel, method = "pearson")
cor.test(aantalburen, aantalstakers_rel, method = "kendall")
cor.test(aantalburen, aantalstakers_rel, method = "spearman")

# create statnet object; equivalent to g
toAnalyze <- asNetwork(nbr_grp)

# ERGM fit
form <- formula(toAnalyze ~ 
                  edges
#                  + kstar(2)
#                  + kstar(3)
#                  + triangle
                  + nodematch("staker")
#                 + nodematch("volhouder")
#                 + nodematch("ontslagen")
                  + nodematch("regio")
                  + nodematch("geloof")
#                  + nodematch("aantal_dienstjaren")
                  + nodematch("werkplaats")
                  + nodematch("HISCLASS")
                  + nodematch("loon_intrapolatie")
#                  + nodematch("inkomen_dummy")
)

fit <- ergm(form)
summary(fit)

odds_ratios <- as.data.frame(round(exp(cbind(ORs = coef(fit))),2))
odds_ratios

# ontslagen
form <- formula(toAnalyze ~ edges +
                  match("staker") +
                  match("regio") +
                  match("geloof") +
                  match("werkplaats") +
                  match("HISCLASS") +
                  match("loon_intrapolatie") +
                  match("inkomen_dummy")
)

fit <- ergm(form)
summary(fit)

odds_ratios <- as.data.frame(round(exp(cbind(ORs = coef(fit))),2))
odds_ratios

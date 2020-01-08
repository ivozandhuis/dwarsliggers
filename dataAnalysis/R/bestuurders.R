# analyse bestuurders graph

setwd("~/git/dwarsliggers/")
source("dataTransformation/R/constructOrganisationgraph.R")

jaarboekje <- read.csv("data/sources/csv/jaarboekje.csv")
bestuurders_nrs <- unique(jaarboekje$my_medewerkersnummer)
organisation_nrs <- unique(jaarboekje$my_organisatienummer)

bestuurders <- df 
bestuurders <- bestuurders[bestuurders$my_medewerkersnummer %in% bestuurders_nrs,]
length(unique(bestuurders$my_medewerkersnummer))

t <- table(bestuurders$staker)
prop.table(t)

rm(jaarboekje)

# SNA

library(statnet)
library(intergraph) # to convert from igraph object to statnet-object

toAnalyze <- df

# basic data org_grp
toAnalyze$org_degree      <- igraph::degree(org_grp)
toAnalyze$org_betweenness <- igraph::betweenness(org_grp)

toAnalyze[toAnalyze$org_degree > 2,]$org_degree <- 10000

cross <- table(toAnalyze$org_degree, toAnalyze$staker)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2

# create statnet object; equivalent to g
toAnalyze <- asNetwork(org_grp)

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

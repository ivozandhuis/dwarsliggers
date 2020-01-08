# analyse family graphs

setwd("~/git/dwarsliggers/")
source("dataTransformation/R/constructFamilygraph.R")

library(statnet)
library(intergraph) # to convert from igraph object to statnet-object

toAnalyze <- df

# basic data fam_grp
toAnalyze$fam_degree      <- igraph::degree(fam_grp)
toAnalyze$fam_betweenness <- igraph::betweenness(fam_grp)

toAnalyze[toAnalyze$fam_degree > 3,]$fam_degree <- 10000

cross <- table(toAnalyze$fam_degree, toAnalyze$staker)
cross_rel <- prop.table(cross, 1)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2

aantalstakers_rel <- as.numeric(cross_rel[,2])
aantalburen <- c(0,1,2,3,4)
cor.test(aantalburen, aantalstakers_rel, method = "pearson")
cor.test(aantalburen, aantalstakers_rel, method = "kendall")
cor.test(aantalburen, aantalstakers_rel, method = "spearman")

# create statnet object; equivalent to g
toAnalyze <- asNetwork(fam_grp)

# ERGM fit
form <- formula(toAnalyze ~ 
                  edges
#                  + gwesp(1)
#                  + kstar(2)
#                  + kstar(3)
                   + triangle
#                  + nodemain("staker")
#                 + nodematch("volhouder")
#                 + nodematch("ontslagen")
#                  + match("regio")
#                  + match("geloof")
#                  + nodematch("aantal_dienstjaren")
#                  + match("werkplaats")
#                  + match("HISCLASS")
#                  + nodemain("loon_intrapolatie")
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

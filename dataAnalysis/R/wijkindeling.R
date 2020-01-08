setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

toAnalyze <- df
toAnalyze <- toAnalyze[(toAnalyze$adres.x != ""),] #select people living in Haarlem
toAnalyze <- droplevels(toAnalyze)

# get table and test independence
cross <- table(toAnalyze$mijn_wijknaam, toAnalyze$staker)
cross
prop.table(cross, 1)
addmargins(cross)
chisq.test(cross)

cross <- table(toAnalyze$mijn_wijknaam, toAnalyze$volhouder)
cross
prop.table(cross, 1)
addmargins(cross)
chisq.test(cross)


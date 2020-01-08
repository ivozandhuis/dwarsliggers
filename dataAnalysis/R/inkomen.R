setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

toAnalyze <- df[!is.na(df$loon),] #select only people we know "loon" of
toAnalyze <- toAnalyze[(toAnalyze$adres.x != ""),] #select people living in Haarlem
toAnalyze[is.na(toAnalyze$inkomen),]$inkomen <- 0
toAnalyze[toAnalyze$inkomen > 600,]$inkomen <- 10000

# get table 
cross <- table(toAnalyze$inkomen, toAnalyze$loon)
cross
addmargins(cross)

# get table and test independence

cross <- table(toAnalyze$inkomen, toAnalyze$staker)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2

cross <- table(toAnalyze$inkomen, toAnalyze$volhouder)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2

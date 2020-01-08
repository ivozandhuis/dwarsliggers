setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

# get table and test independence


toAnalyze <- df
toAnalyze <- toAnalyze[(toAnalyze$staker == "TRUE"),]
toAnalyze <- toAnalyze[(toAnalyze$volhouder == "TRUE"),]
toAnalyze <- droplevels(toAnalyze)


cross <- table(toAnalyze$HISCO_unit, toAnalyze$ontslagen)
cross
prop.table(cross, 1)
addmargins(cross)
chisq.test(cross)


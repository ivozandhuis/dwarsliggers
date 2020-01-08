setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

# get table and test independence
cross <- table(df$HISCLASS, df$staker)
cross
prop.table(cross, 1)
addmargins(cross)
chisq.test(cross)

toAnalyze <- df
toAnalyze <- df[!(df$HISCLASS == "6"),]
toAnalyze <- droplevels(toAnalyze)

cross <- table(toAnalyze$HISCLASS, toAnalyze$staker)
cross
prop.table(cross, 1)
addmargins(cross)
chisq.test(cross)

cross <- table(toAnalyze$HISCLASS, toAnalyze$volhouder)
cross
prop.table(cross, 1)
addmargins(cross)
chisq.test(cross)

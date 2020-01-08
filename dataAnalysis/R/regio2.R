setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

toAnalyze <- df

toAnalyze <- df[!(df$regio2 == "buitenland"),]
toAnalyze <- droplevels(toAnalyze)

# get table and test independence
cross <- table(toAnalyze$regio2, toAnalyze$staker)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))
cramers_v

cross <- table(toAnalyze$regio2, toAnalyze$volhouder)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))

cross <- table(toAnalyze$regio2, toAnalyze$ontslagen)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))
cramers_v

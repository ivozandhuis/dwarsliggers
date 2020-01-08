setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

toAnalyze <- df[df$huw_st != "O" & df$huw_st != "S",]

brks = c(0, 1, 2, 3, 4, 5, 6, 7, 10)
toAnalyze$kidsGroup <- cut(toAnalyze$aantal_kinderen, breaks=brks, right = FALSE)

# get table and test independence
cross <- table(toAnalyze$kidsGroup, toAnalyze$staker)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))

cross <- table(toAnalyze$kidsGroup, toAnalyze$volhouder)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))


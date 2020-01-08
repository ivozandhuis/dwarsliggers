setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

# brks = seq(1.35,2.05,by=0.1)
brks = c(0.95, 1.45, 1.55, 1.65, 1.75, 1.85, 1.95, 4)
df$loonGroep <- cut(df$loon_intrapolatie, breaks=brks, right = FALSE)

# get table and test independence
cross <- table(df$loonGroep, df$staker)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))

cross <- table(df$loonGroep, df$volhouder)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))

cross <- table(toAnalyze$loonGroep, toAnalyze$ontslagen)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))
cramers_v

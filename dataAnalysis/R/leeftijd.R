setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

brks = c(15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 80)
df$ageGroup <- cut(df$leeftijd, breaks=brks)

# get table and test independence
cross <- table(df$ageGroup, df$staker)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))

# volhouders
brks = c(15, 20, 25, 30, 35, 40, 45, 50, 80)
df$ageGroup <- cut(df$leeftijd, breaks=brks)

cross <- table(df$ageGroup, df$volhouder)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))

cross <- table(df$ageGroup, df$ontslagen)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))
cramers_v

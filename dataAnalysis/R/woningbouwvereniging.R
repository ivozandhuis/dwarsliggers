setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

# get table and test independence
cross <- table(df$woningbouwvereniging, df$staker)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))

cross <- table(df$woningbouwvereniging, df$volhouder)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))

cross <- table(df$woningbouwvereniging, df$ontslagen)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))
cramers_v

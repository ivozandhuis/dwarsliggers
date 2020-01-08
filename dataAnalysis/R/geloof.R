setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

# get table and test independence
cross <- table(df$geloof, df$staker)
cross
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
sqrt(chi2$statistic / sum(cross))

cross <- table(df$geloof, df$volhouder)
cross
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
sqrt(chi2$statistic / sum(cross))

cross <- table(df$geloof, df$ontslagen)
cross
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
sqrt(chi2$statistic / sum(cross))

# gemengd gehuwden
cross <- table(df$gemengd_huw, df$staker)
cross
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
sqrt(chi2$statistic / sum(cross))

cross <- table(df$gemengd_huw, df$volhouder)
cross
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
sqrt(chi2$statistic / sum(cross))

cross <- table(df$gemengd_huw, df$ontslagen)
cross
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
sqrt(chi2$statistic / sum(cross))

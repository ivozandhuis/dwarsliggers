setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

brks = c(0, 5, 10, 15, 20, 25, 60)
df$aantal_dienstjarenGroep <- cut(df$aantal_dienstjaren, breaks=brks, right = FALSE)

# get table and test independence
cross <- table(df$aantal_dienstjarenGroep, df$staker)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))

brks = c(0, 5, 10, 15, 20, 60)
df$aantal_dienstjarenGroep <- cut(df$aantal_dienstjaren, breaks=brks, right = FALSE)

cross <- table(df$aantal_dienstjarenGroep, df$volhouder)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))

cross <- table(df$aantal_dienstjarenGroep, df$ontslagen)
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
cramers_v <- sqrt(chi2$statistic / sum(cross))
cramers_v

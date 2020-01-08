setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

# filter medewerkers without geo-location
toAnalyze <- df
toAnalyze <- toAnalyze[(toAnalyze$adres.x != ""),] #select people living in Haarlem

# remove unused levels in kiesdistrict_GR1899
toAnalyze <- droplevels(toAnalyze)

# get table and test independence
cross <- table(toAnalyze$kiesdistrict_GR1899, toAnalyze$staker)
cross
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
sqrt(chi2$statistic / sum(cross))

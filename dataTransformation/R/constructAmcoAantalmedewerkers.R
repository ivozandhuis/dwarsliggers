setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

# how much employees are there born in every municipality (defined by Amsterdam Code)?
# input for QGIS

amco_numberemployees <- as.data.frame(table(df$amco))

# remove to big numbers (Haarlem en Amsterdam)
amco_numberemployees$Freq[amco_numberemployees$Freq > 20] <- 0

# test
amco_numberemployees
sum(amco_numberemployees$Freq)

# write
write.table(amco_numberemployees, "data/constructs/csv/amcoAantalmedewerkers.csv", sep = ",", row.names=FALSE, col.names = c("amsterdam_code","value"))

rm(amco_numberemployees)
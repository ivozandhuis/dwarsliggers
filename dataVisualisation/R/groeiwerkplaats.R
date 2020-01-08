setwd("~/git/dwarsliggers/")
aantal_medewerkers <- read.csv("data/sources/csv/groeiwerkplaats.csv")
plot(aantal_medewerkers$jaar, aantal_medewerkers$aantal_medewerkers, type = "o", ann=FALSE)
title(xlab = "jaar", ylab = "aantal medewerkers")

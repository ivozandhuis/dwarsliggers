setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

summary(df)
totalen <- table(df$kleur)

#percentages
totalen
totalen[1] / sum(totalen)
totalen[2] / sum(totalen)
totalen[3] / sum(totalen)
totalen[4] / sum(totalen)

# employees that did not strike at first, but lateron they did
outliers <- medewerkerslijst[medewerkerslijst$ma_vm_aantal_uur > medewerkerslijst$wo_nm_aantal_uur,]

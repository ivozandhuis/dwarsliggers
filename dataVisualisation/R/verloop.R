setwd("~/git/dwarsliggers/")
source("dataTransformation/R/transformMedewerkerslijst.R")

library(plyr)
v <- vector(length=0)

cnt <- count(medewerkerslijst$ma_vm_aantal_uur == 0)
v <- c(v, cnt[2,]$freq)

cnt <- count(medewerkerslijst$ma_nm_aantal_uur == 0)
v <- c(v, cnt[2,]$freq)

cnt <- count(medewerkerslijst$di_vm_aantal_uur == 0)
v <- c(v, cnt[2,]$freq)

cnt <- count(medewerkerslijst$di_nm_aantal_uur == 0)
v <- c(v, cnt[2,]$freq)

cnt <- count(medewerkerslijst$wo_vm_aantal_uur == 0)
v <- c(v, cnt[2,]$freq)

cnt <- count(medewerkerslijst$wo_nm_aantal_uur == 0)
v <- c(v, cnt[2,]$freq)

names(v) <- c("maandagmorgen", 
              "maandagmiddag",
              "dinsdagmorgen",
              "dinsdagmiddag",
              "woensdagmorgen",
              "woensdagmiddag")

par(mar=c(10, 5, 3, 3))
barplot(v, 
        las = 2,
        ylim= c(0,750))

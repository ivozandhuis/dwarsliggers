setwd("~/git/dwarsliggers/")

# install hisco:
# > install.packages("devtools")
# > library(devtools)
# > install_github("junkka/hisco")

library(hisco)

# read medewerkerslijst
medewerkerslijst <- read.csv("data/sources/csv/medewerkerslijst.csv")

# add color as a factor
medewerkerslijst$kleur_factor <- factor(medewerkerslijst$kleur, levels = c("b","w","g","r"), ordered=TRUE)

# remove observations of employees sick or conscripted (that is: have a reason for not working)
medewerkerslijst <- medewerkerslijst[(medewerkerslijst$ma_vm_reden==''),]
medewerkerslijst <- medewerkerslijst[(medewerkerslijst$ma_nm_reden==''),]
medewerkerslijst <- medewerkerslijst[(medewerkerslijst$di_vm_reden==''),]
medewerkerslijst <- medewerkerslijst[(medewerkerslijst$di_nm_reden==''),]
medewerkerslijst <- medewerkerslijst[(medewerkerslijst$wo_vm_reden==''),]
medewerkerslijst <- medewerkerslijst[(medewerkerslijst$wo_nm_reden==''),]

###############
# combine workplaces that are too small
levels(medewerkerslijst$werkplaats) <- c(levels(medewerkerslijst$werkplaats),"Slagerij_gieterij")
levels(medewerkerslijst$werkplaats) <- c(levels(medewerkerslijst$werkplaats),"Zeil_zadelmakerij")
medewerkerslijst$werkplaats_org <- medewerkerslijst$werkplaats

medewerkerslijst$werkplaats[which(medewerkerslijst$werkplaats_org == "Kopergieterij")]      <- "Slagerij_gieterij"
medewerkerslijst$werkplaats[which(medewerkerslijst$werkplaats_org == "Koperslagerij")]      <- "Slagerij_gieterij"
medewerkerslijst$werkplaats[which(medewerkerslijst$werkplaats_org == "Blikslagerij")]       <- "Slagerij_gieterij"
medewerkerslijst$werkplaats[which(medewerkerslijst$werkplaats_org == "Compositiegieterij")] <- "Slagerij_gieterij"

medewerkerslijst$werkplaats[which(medewerkerslijst$werkplaats_org == "Houtloods")]          <- "Wagenmakerij"
medewerkerslijst$werkplaats[which(medewerkerslijst$werkplaats_org == "Balkenzagerij")]      <- "Wagenmakerij"

medewerkerslijst$werkplaats[which(medewerkerslijst$werkplaats_org == "Zadelmakerij")]       <- "Zeil_zadelmakerij"
medewerkerslijst$werkplaats[which(medewerkerslijst$werkplaats_org == "Zeilmakerij")]        <- "Zeil_zadelmakerij"

###############
# add sum of worked hours
medewerkerslijst$aantal_uur <- 
  medewerkerslijst$ma_vm_aantal_uur +
  medewerkerslijst$ma_nm_aantal_uur +
  medewerkerslijst$di_vm_aantal_uur +
  medewerkerslijst$di_nm_aantal_uur +
  medewerkerslijst$wo_vm_aantal_uur +
  medewerkerslijst$wo_nm_aantal_uur

##############
# add changes in behaviour
medewerkerslijst$t0 <-  (medewerkerslijst$ma_vm_aantal_uur == 0)
medewerkerslijst$t1 <-  (medewerkerslijst$ma_nm_aantal_uur == 0)
medewerkerslijst$t2 <-  (medewerkerslijst$di_vm_aantal_uur == 0)
medewerkerslijst$t3 <-  (medewerkerslijst$di_nm_aantal_uur == 0)
medewerkerslijst$t4 <-  (medewerkerslijst$wo_vm_aantal_uur == 0)
medewerkerslijst$t5 <-  (medewerkerslijst$wo_nm_aantal_uur == 0)

medewerkerslijst$aantal_wisselingen <- 0
medewerkerslijst[medewerkerslijst$t0 != medewerkerslijst$t1,]$aantal_wisselingen <- medewerkerslijst[medewerkerslijst$t0 != medewerkerslijst$t1,]$aantal_wisselingen + 1
medewerkerslijst[medewerkerslijst$t1 != medewerkerslijst$t2,]$aantal_wisselingen <- medewerkerslijst[medewerkerslijst$t1 != medewerkerslijst$t2,]$aantal_wisselingen + 1
medewerkerslijst[medewerkerslijst$t2 != medewerkerslijst$t3,]$aantal_wisselingen <- medewerkerslijst[medewerkerslijst$t2 != medewerkerslijst$t3,]$aantal_wisselingen + 1
medewerkerslijst[medewerkerslijst$t3 != medewerkerslijst$t4,]$aantal_wisselingen <- medewerkerslijst[medewerkerslijst$t3 != medewerkerslijst$t4,]$aantal_wisselingen + 1
medewerkerslijst[medewerkerslijst$t4 != medewerkerslijst$t5,]$aantal_wisselingen <- medewerkerslijst[medewerkerslijst$t4 != medewerkerslijst$t5,]$aantal_wisselingen + 1

###############
# add standardized profession
functie_std <- read.csv("data/sources/csv/functie_std.csv")
medewerkerslijst <- merge(medewerkerslijst, functie_std, by = c("werkplaats_org","functie"), all.x = TRUE)

medewerkerslijst$HISCLASS <- hisco_to_ses(medewerkerslijst$HISCO)
medewerkerslijst$HISCLASS <- as.factor(medewerkerslijst$HISCLASS)

medewerkerslijst$SOCPO <- hisco_to_ses(medewerkerslijst$HISCO, "socpo")
medewerkerslijst$SOCPO <- as.factor(medewerkerslijst$SOCPO)

# introduce HISCO major (first digit), minor (first two digits) and unit groups (first three digits)
medewerkerslijst$HISCO_major <- medewerkerslijst$HISCO %/% 10000
medewerkerslijst$HISCO_minor <- medewerkerslijst$HISCO %/% 1000
medewerkerslijst$HISCO_unit <- medewerkerslijst$HISCO %/% 100

medewerkerslijst$HISCO_major <- as.factor(medewerkerslijst$HISCO_major)
medewerkerslijst$HISCO_minor <- as.factor(medewerkerslijst$HISCO_minor)
medewerkerslijst$HISCO_unit <- as.factor(medewerkerslijst$HISCO_unit)
medewerkerslijst$HISCO_micro <- as.factor(medewerkerslijst$HISCO)

###############
# add opzichter
organogram <- read.csv("data/sources/csv/organogram.csv")
opzichters <- unique(organogram[c("werkplaats","opzichter")])
medewerkerslijst <- merge(medewerkerslijst, opzichters, by = "werkplaats", all.x = TRUE)

# remove temporary stuff
rm(functie_std)
rm(opzichters)
rm(organogram)

# *******************
medewerkerslijst$werkplaats <- as.factor(medewerkerslijst$werkplaats)


setwd("~/git/dwarsliggers/")

personeelsregister_basis <- read.csv("data/sources/csv/personeelsregister_basis.csv")
personeelsregister_index <- read.csv("data/sources/csv/personeelsregister_index.csv")
personeelsregister_boetes <- read.csv("data/sources/csv/personeelsregister_boetes.csv")

personeelsregister <- merge(personeelsregister_basis, personeelsregister_index, by = "my_medewerkersnummer", all=TRUE)

# **************
# add "aantal_dienstjaren"
age = function(from, to) {
  from_lt = as.POSIXlt(from)
  to_lt = as.POSIXlt(to)
  age = to_lt$year - from_lt$year
  ifelse(to_lt$mon < from_lt$mon |
           (to_lt$mon == from_lt$mon & to_lt$mday < from_lt$mday),
         age - 1, age)
}

personeelsregister$dienstjaren_persreg <- age(personeelsregister$datum_in_dienst, "1903-04-06")

# remove all negative aantal_dienstjaren
personeelsregister[!is.na(personeelsregister$dienstjaren_persreg) & personeelsregister$dienstjaren_persreg<0,]$dienstjaren_persreg <- NA

# select the best value for aantal_dienstjaren, 
# first persreg, else medewerkerslijst, else schatting
personeelsregister <- within(personeelsregister,
                    aantal_dienstjaren <- ifelse(!is.na(dienstjaren_persreg), dienstjaren_persreg, dienstjaren_medewerkerslijst)
)

personeelsregister <- within(personeelsregister,
                    aantal_dienstjaren <- ifelse(is.na(aantal_dienstjaren), dienstjaren_schatting, aantal_dienstjaren)
)

##################
# transform boetes
gestraften <- data.frame(table(personeelsregister_boetes$my_medewerkersnummer))
names(gestraften)[1] <- "my_medewerkersnummer"
names(gestraften)[2] <- "aantal_vergrijpen"

straffen <- data.frame(table(personeelsregister_boetes$my_medewerkersnummer[personeelsregister_boetes$soort_vergrijp == "subversiviteit"]))
names(straffen)[1] <- "my_medewerkersnummer"
names(straffen)[2] <- "aantal_subversiviteit"
gestraften <- merge(gestraften, straffen, all.x = TRUE)
gestraften$aantal_subversiviteit[is.na(gestraften$aantal_subversiviteit)] <- 0

straffen <- data.frame(table(personeelsregister_boetes$my_medewerkersnummer[personeelsregister_boetes$soort_vergrijp == "misbruik"]))
names(straffen)[1] <- "my_medewerkersnummer"
names(straffen)[2] <- "aantal_misbruik"
gestraften <- merge(gestraften, straffen, all.x = TRUE)
gestraften$aantal_misbruik[is.na(gestraften$aantal_misbruik)] <- 0

straffen <- data.frame(table(personeelsregister_boetes$my_medewerkersnummer[personeelsregister_boetes$soort_vergrijp == "wangedrag"]))
names(straffen)[1] <- "my_medewerkersnummer"
names(straffen)[2] <- "aantal_wangedrag"
gestraften <- merge(gestraften, straffen, all.x = TRUE)
gestraften$aantal_wangedrag[is.na(gestraften$aantal_wangedrag)] <- 0

straffen <- data.frame(table(personeelsregister_boetes$my_medewerkersnummer[personeelsregister_boetes$soort_vergrijp == "niet werken"]))
names(straffen)[1] <- "my_medewerkersnummer"
names(straffen)[2] <- "aantal_niet_werken"
gestraften <- merge(gestraften, straffen, all.x = TRUE)
gestraften$aantal_niet_werken[is.na(gestraften$aantal_niet_werken)] <- 0

straffen <- data.frame(table(personeelsregister_boetes$my_medewerkersnummer[personeelsregister_boetes$soort_vergrijp == "slecht werk"]))
names(straffen)[1] <- "my_medewerkersnummer"
names(straffen)[2] <- "aantal_slecht_werk"
gestraften <- merge(gestraften, straffen, all.x = TRUE)
gestraften$aantal_slecht_werk[is.na(gestraften$aantal_slecht_werk)] <- 0

# ik weeg hier zelf de zwaarte van een soort vergrijp. Is de eigentijdse zwaarte te incorporeren?
# alcohol geldt bijvoorbeeld als een zwaar vergrijp, ik classificeer deze als "wangedrag".
gestraften$vergrijpzwaarte <- 
  gestraften$aantal_subversiviteit * 5 +
  gestraften$aantal_misbruik * 4 +
  gestraften$aantal_wangedrag * 3 +
  gestraften$aantal_niet_werken * 2 +
  gestraften$aantal_slecht_werk

# todo: wel in personeelsregister_basis maar niet *boetes, betekent aantal boets is "0" ipv "NA"

personeelsregister <- merge(personeelsregister, gestraften, all.x = TRUE)

# remove empty observations
personeelsregister <- personeelsregister[!is.na(personeelsregister$my_medewerkersnummer),]

###########
# remove temporary stuff
rm(personeelsregister_basis)
rm(personeelsregister_index)
rm(personeelsregister_boetes)
rm(gestraften)
rm(straffen)
rm(age)

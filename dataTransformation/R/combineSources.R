setwd("~/git/dwarsliggers/")

source("dataTransformation/R/transformMedewerkerslijst.R")
source("dataTransformation/R/transformBevolkingsregister.R")
source("dataTransformation/R/transformPersoneelsregister.R")
source("dataTransformation/R/transformBelastingkohier.R")
source("dataTransformation/R/transformRoutes.R")

# combine medewerkerslijst and bevolkingsregister first. 
# NB. in this action 19 RPs are removed, because they were not found in de bevolkingsregister.
df <- merge(medewerkerslijst, bevolkingsregister, by = "my_medewerkersnummer")
df <- merge(df, personeelsregister, by = "my_medewerkersnummer", all.x = TRUE)
df <- merge(df, belastingkohier, by = "my_medewerkersnummer", all.x = TRUE)
df <- merge(df, routes, by = "my_medewerkersnummer", all.x = TRUE)

# create dummy "married"
df$gehuwd_dummy[df$huw_st == "H"] <- 1
df$gehuwd_dummy[df$huw_st == "O"] <- 0
df$gehuwd_dummy[df$huw_st == "S"] <- 0
df$gehuwd_dummy[df$huw_st == "W"] <- 0

# replace wrong df$aantal_dienstjaren with average
df$aantal_dienstjaren[(df$leeftijd - df$aantal_dienstjaren) < 12] <- NA
df$aantal_dienstjaren[df$leeftijd == 16] <- 0
aantal_dienstjaren_avg <- aggregate(df$aantal_dienstjaren, list(df$leeftijd), mean, na.rm=TRUE, na.action=NULL)
df <- merge(df, aantal_dienstjaren_avg, by.x = "leeftijd", by.y = "Group.1", all.x = TRUE)

df <- within(df,
             aantal_dienstjaren <- ifelse(!is.na(aantal_dienstjaren), aantal_dienstjaren, round(x)))

# remove temp-stuf
rm(aantal_dienstjaren_avg)
df$x <- NULL

# add df$loon_intrapolatie for missing df$loon with averages
# cleanup: list of variables to select
loon_avg1 <- aggregate(loon~functie.x+werkplaats, df[df$loonsoort == "dagloon",], mean)
loon_avg2 <- aggregate(loon~HISCO, df[df$loonsoort == "dagloon",], mean)

names(loon_avg1) <- c("functie.x","werkplaats","loon_avg1")
names(loon_avg2) <- c("HISCO","loon_avg2")

df <- merge(df, loon_avg1, by = c("werkplaats","functie.x"), all.x = TRUE)
df <- merge(df, loon_avg2, by = "HISCO", all.x = TRUE)

# select the best value for loon_intrapolatie, 
# first loon, else loon_avg1, else loon_avg2
df$loon[df$loonsoort == "maandloon"] <- NA

count <- df[!is.na(df$loon),]
count <- df[(is.na(df$loon) & !is.na(df$loon_avg1)),]
count <- df[(is.na(df$loon) & is.na(df$loon_avg1) & !is.na(df$loon_avg2)),]
count <- df[(is.na(df$loon) & is.na(df$loon_avg1) & is.na(df$loon_avg2)),]

df <- within(df,
            loon_intrapolatie <- ifelse(!is.na(loon), loon, loon_avg1)
)

count <- df[(is.na(df$loon_intrapolatie) & !is.na(df$loon_avg2)),]
df <- within(df,
             loon_intrapolatie <- ifelse(is.na(loon_intrapolatie), loon_avg2, loon_intrapolatie)
)

count <- df[is.na(df$loon_intrapolatie),]
df$loon_intrapolatie[is.na(df$loon_intrapolatie)] <- 1.84

rm(loon_avg1)
rm(loon_avg2)
rm(count)
df$loon_avg1 <- NULL
df$loon_avg2 <- NULL

# create dummy for inkomen
df$inkomen_dummy[is.na(df$inkomen)]  <- 0
df$inkomen_dummy[!is.na(df$inkomen)] <- 1

# cleanup: list of variables to select
selection = c(
  "my_medewerkersnummer",
  "aantal_uur",
  "achternaam.x",
  "functie.x",
  "gebdat",
  "gebpla",
  "amco",
  "kleur",
  "leeftijd",
  "provincie",
  "regio",
  "regio2",
  "geloof",
  "gemengd_huw",
  "type",
  "werkplaats",
  "afdeling",
  "loon",
  "loon_intrapolatie",
  "loonsoort",
  "inkomen",
  "inkomen_dummy",
  "aantal_dienstjaren",
  "HISCO",
  "HISCO_major",
  "HISCO_minor",
  "HISCO_unit",
  "HISCLASS",
  "SOCPO",
  "huw_st",
  "gehuwd_dummy",
  "aantal_gezinsleden",
  "aantal_kinderen",
  "kinderen_dummy",
  "gem_leeftijd_kinderen",
  "verantwoordelijkheid",
  "mijn_wijknaam",
  "adres.x",
  "afdeling_kohier",
  "kiesdistrict_GR1899",
  "woningbouwvereniging", 
  "len",
  "t0",
  "t1",
  "t2",
  "t3",
  "t4",
  "t5",
  "aantal_wisselingen"
)

df <- subset(df, select = selection)

# create stakers, volhouders en ontslagen info, derived from df$kleur
# TRUE/FALSE
df$staker <- TRUE
df$staker[df$kleur == 'b'] <- FALSE

df$volhouder <- NA
df$volhouder[df$staker] <- TRUE
df$volhouder[df$kleur == 'w'] <- FALSE

df$ontslagen <- NA
df$ontslagen[df$volhouder] <- TRUE
df$ontslagen[df$kleur == 'g'] <- FALSE

# remove unused levels in all factors
df <- droplevels(df)

# write
write.table(df, "data/constructs/csv/df.csv", sep = ",", row.names=FALSE)

# remove temporary stuff
rm(belastingkohier)
rm(bevolkingsregister)
rm(medewerkerslijst)
rm(personeelsregister)
rm(routes)

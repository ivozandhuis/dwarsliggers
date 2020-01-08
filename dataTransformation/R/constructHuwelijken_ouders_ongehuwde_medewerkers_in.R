# read bevolkingsregister
setwd("~/git/dwarsliggers/")

bevolkingsregister <- read.csv("data/sources/csv/bevolkingsregister.csv")

# **************************
# add "leeftijd", ages on April 6th 1903, start of the strike
age = function(from, to) {
  from_lt = as.POSIXlt(from)
  to_lt = as.POSIXlt(to)
  age = to_lt$year - from_lt$year
  ifelse(to_lt$mon < from_lt$mon |
           (to_lt$mon == from_lt$mon & to_lt$mday < from_lt$mday),
         age - 1, age)
}

bevolkingsregister$leeftijd <- age(bevolkingsregister$gebdat, "1903-04-06")
# remove all unborn children
bevolkingsregister <- bevolkingsregister[bevolkingsregister$leeftijd>-1,]

# remove temporary stuff
rm(age)

# **************************
# create huwelijken, marriage between people with different religion

zonen   <- bevolkingsregister[(bevolkingsregister$type == "zoon") & !(is.na(bevolkingsregister$my_medewerkersnummer)) ,]
vaders  <- bevolkingsregister[(bevolkingsregister$type == "hoofd"),]
moeders <- bevolkingsregister[(bevolkingsregister$type == "vrouw"),]
huwelijken <- merge(vaders, moeders, by = "huishouden_id")
huwelijken <- merge(zonen, huwelijken, by = "huishouden_id")
# remove temporary stuff

rm(zonen)
rm(vaders)
rm(moeders)
rm(bevolkingsregister)

# cleanup: list of variables to select

selection = c(
  "my_medewerkersnummer",
  "achternaam",
  "tussenvoegsel",
  "voornaam",
  "achternaam.x",
  "tussenvoegsel.x",
  "voornaam.x",
  "leeftijd.x",
  "achternaam.y",
  "tussenvoegsel.y",
  "voornaam.y",
  "leeftijd.y"
)

huwelijken <- subset(huwelijken, select = selection)

huwelijken$achternaam.x    <- trimws(huwelijken$achternaam.x)
huwelijken$tussenvoegsel.x <- trimws(huwelijken$tussenvoegsel.x)
huwelijken$voornaam.x      <- trimws(huwelijken$voornaam.x)
huwelijken$achternaam.y    <- trimws(huwelijken$achternaam.y)
huwelijken$tussenvoegsel.y <- trimws(huwelijken$tussenvoegsel.y)
huwelijken$voornaam.y      <- trimws(huwelijken$voornaam.y)

huwelijken$voor      <- 1903
huwelijken$na        <- (1903 - pmin(huwelijken$leeftijd.x, huwelijken$leeftijd.y) + 15)

huwelijken$leeftijd.x <- NULL
huwelijken$leeftijd.y <- NULL
# write
write.table(huwelijken, "data/constructs/csv/huwelijken_ouders_ongehuwde_medewerkers_in.csv", sep = ",", row.names=FALSE)

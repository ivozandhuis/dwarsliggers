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

rm(age)

# **************************
# create gemeentetable
source("dataTransformation/R/constructGemeentes.R")

# add standardized municipality and extra information for every RP in bevolkingsregister
gebpla_std <- read.csv("data/sources/csv/gebpla_std.csv")
gebpla_std_ext <- merge(gebpla_std, gemeentes, by = "uri_naam", all.x = TRUE)
bevolkingsregister <- merge(bevolkingsregister, gebpla_std_ext, by = "my_medewerkersnummer", all.x = TRUE)

# regio: indeling in buitenland/noord/oost/zuid/west/haarlem_eo
bevolkingsregister$regio[substring(bevolkingsregister$uri_naam, 1, nchar("http://www.gemeentegeschiedenis.nl/")) != "http://www.gemeentegeschiedenis.nl/"] <- "buitenland"
bevolkingsregister$regio[which(bevolkingsregister$amco == 10357)] <- "haarlem_eo" # Haarlem
bevolkingsregister$regio[which(bevolkingsregister$amco == 10850)] <- "haarlem_eo" # Bloemendaal
bevolkingsregister$regio[which(bevolkingsregister$amco == 11288)] <- "haarlem_eo" # Heemstede
bevolkingsregister$regio[which(bevolkingsregister$amco == 10382)] <- "haarlem_eo" # Schoten
bevolkingsregister$regio[which(bevolkingsregister$amco == 10041)] <- "haarlem_eo" # Haarlemmerliede (& Spaarnwoude)
bevolkingsregister$regio[which(bevolkingsregister$amco == 10508)] <- "haarlem_eo" # Spaarnwoude
bevolkingsregister$regio <- as.factor(bevolkingsregister$regio)

# regio2: indeling in buitenland/noordoost/noordwest/zuidoost/zuidwest/haarlem_eo
bevolkingsregister$regio2[substring(bevolkingsregister$uri_naam, 1, nchar("http://www.gemeentegeschiedenis.nl/")) != "http://www.gemeentegeschiedenis.nl/"] <- "buitenland"
bevolkingsregister$regio2[which(bevolkingsregister$amco == 10357)] <- "haarlem_eo" # Haarlem
bevolkingsregister$regio2[which(bevolkingsregister$amco == 10850)] <- "haarlem_eo" # Bloemendaal
bevolkingsregister$regio2[which(bevolkingsregister$amco == 11288)] <- "haarlem_eo" # Heemstede
bevolkingsregister$regio2[which(bevolkingsregister$amco == 10382)] <- "haarlem_eo" # Schoten
bevolkingsregister$regio2[which(bevolkingsregister$amco == 10041)] <- "haarlem_eo" # Haarlemmerliede (& Spaarnwoude)
bevolkingsregister$regio2[which(bevolkingsregister$amco == 10508)] <- "haarlem_eo" # Spaarnwoude
bevolkingsregister$regio2 <- as.factor(bevolkingsregister$regio2)

# remove temporary dfs
rm(gebpla_std)
rm(gebpla_std_ext)
rm(gemeentes)

#################
# add standardized neighbourhood (wijk) for every RP in bevolkingsregister
wijken <- read.csv("data/sources/csv/wijkindeling.csv")
bevolkingsregister <- merge(bevolkingsregister, wijken, by = "my_medewerkersnummer", all.x = TRUE)

bevolkingsregister$afdeling_kohier <- as.factor(bevolkingsregister$afdeling_kohier)
bevolkingsregister$kiesdistrict_GR1899 <- as.factor(bevolkingsregister$kiesdistrict_GR1899)

rm(wijken)

# **************************
# add "geloof", standardized religion
# slice it up into various religions and "rest"
bevolkingsregister$geloof <- "overig"
bevolkingsregister$geloof[bevolkingsregister$religie != ""] <- "overig"
bevolkingsregister$geloof[bevolkingsregister$religie == "nh"] <- "nh"
bevolkingsregister$geloof[bevolkingsregister$religie == "rk"] <- "rk"
bevolkingsregister$geloof[bevolkingsregister$religie == "[rk]"] <- "rk"
bevolkingsregister$geloof[bevolkingsregister$religie == "el"] <- "vrijz"
bevolkingsregister$geloof[bevolkingsregister$religie == "dg"] <- "vrijz"
bevolkingsregister$geloof[bevolkingsregister$religie == "rem."] <- "vrijz"
bevolkingsregister$geloof[bevolkingsregister$religie == "cg"] <- "gk"
bevolkingsregister$geloof[bevolkingsregister$religie == "ger."] <- "gk"
bevolkingsregister$geloof[bevolkingsregister$religie == "ger. Kerken"] <- "gk"
bevolkingsregister$geloof[bevolkingsregister$religie == "gk"] <- "gk"
bevolkingsregister$geloof[bevolkingsregister$religie == "dol"] <- "gk"

bevolkingsregister$geloof <- as.factor(bevolkingsregister$geloof)

# **************************
# add "gemengd_huw", marriage between people with different religion
vrouwen <- bevolkingsregister[(bevolkingsregister$type == "vrouw"),]
hoofden <- bevolkingsregister[(bevolkingsregister$type == "hoofd"),]
huwelijken <- merge(hoofden, vrouwen, by = "huishouden_id")
gemengde_huwelijken <- huwelijken[(huwelijken$geloof.x != huwelijken$geloof.y),]

bevolkingsregister$gemengd_huw <- (bevolkingsregister$huishouden_id %in% gemengde_huwelijken$huishouden_id)
bevolkingsregister$gemengd_huw[is.na(bevolkingsregister$geloof)] <- NA
bevolkingsregister$gemengd_huw[bevolkingsregister$huw_st != "H"] <- NA

# remove temporary stuff
rm(vrouwen)
rm(hoofden)
rm(huwelijken)
rm(gemengde_huwelijken)

# **************************
# add aantal_gezinsleden, aantal_kinderen (<14), aantal senioren (>64), gem_leeftijd_kinderen, kinderen_dummy
famsize <- data.frame(table(bevolkingsregister$huishouden_id))
names(famsize)[1] <- "huishouden_id"
names(famsize)[2] <- "aantal_gezinsleden"

children <- bevolkingsregister[(bevolkingsregister$leeftijd<14),]
nrchildren <- data.frame(table(children$huishouden_id))
names(nrchildren)[1] <- "huishouden_id"
names(nrchildren)[2] <- "aantal_kinderen"

seniors <- bevolkingsregister[((bevolkingsregister$leeftijd>64) & (bevolkingsregister$type != "hoofd") & (bevolkingsregister$type != "vrouw")),]
nrseniors <- data.frame(table(seniors$huishouden_id))
names(nrseniors)[1] <- "huishouden_id"
names(nrseniors)[2] <- "aantal_bejaarden"
# nrseniors$aantal_bejaarden[is.na(nrseniors$aantal_bejaarden)] <- 0

gem_leeftijd <- aggregate(children[, c("leeftijd")], list(children$huishouden_id), mean)
names(gem_leeftijd)[1] <- "huishouden_id"
names(gem_leeftijd)[2] <- "gem_leeftijd_kinderen"

famsituation <- merge(nrchildren, gem_leeftijd, by = "huishouden_id")
famsituation <- merge(famsize, famsituation, by = "huishouden_id", all.x = TRUE)
famsituation <- merge(famsituation, nrseniors, by = "huishouden_id", all.x = TRUE)
famsituation$aantal_kinderen[is.na(famsituation$aantal_kinderen)] <- 0
famsituation$aantal_bejaarden[is.na(famsituation$aantal_bejaarden)] <- 0

bevolkingsregister <- merge(bevolkingsregister, famsituation, by = "huishouden_id", all.x = TRUE)

bevolkingsregister$kinderen_dummy[bevolkingsregister$aantal_kinderen > 0]  <- 1
bevolkingsregister$kinderen_dummy[bevolkingsregister$aantal_kinderen == 0] <- 0

bevolkingsregister$verantwoordelijkheid <- bevolkingsregister$aantal_kinderen + bevolkingsregister$aantal_bejaarden
bevolkingsregister[bevolkingsregister$huw_st == "H",]$verantwoordelijkheid <- bevolkingsregister[bevolkingsregister$huw_st == "H",]$verantwoordelijkheid + 1

# remove temporary stuff
rm(famsize)
rm(children)
rm(nrchildren)
rm(seniors)
rm(nrseniors)
rm(gem_leeftijd)
rm(famsituation)


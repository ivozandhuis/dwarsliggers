setwd("~/git/dwarsliggers/")

# get dataframe gemeentes of municipalities per province
# csv-files from gemeentegeschiedenis.nl

gemeentes <- read.csv("data/standards/gemeentes/Groningen.csv")
addition <- read.csv("data/standards/gemeentes/Friesland.csv")
gemeentes <- rbind(gemeentes, addition)
addition <- read.csv("data/standards/gemeentes/Drenthe.csv")
gemeentes <- rbind(gemeentes, addition)
addition <- read.csv("data/standards/gemeentes/Overijssel.csv")
gemeentes <- rbind(gemeentes, addition)
addition <- read.csv("data/standards/gemeentes/Gelderland.csv")
gemeentes <- rbind(gemeentes, addition)
addition <- read.csv("data/standards/gemeentes/Utrecht.csv")
gemeentes <- rbind(gemeentes, addition)
addition <- read.csv("data/standards/gemeentes/Noord-Brabant.csv")
gemeentes <- rbind(gemeentes, addition)
addition <- read.csv("data/standards/gemeentes/Noord-Holland.csv")
gemeentes <- rbind(gemeentes,addition)
addition <- read.csv("data/standards/gemeentes/Zuid-Holland.csv")
gemeentes <- rbind(gemeentes,addition)
addition <- read.csv("data/standards/gemeentes/Zeeland.csv")
gemeentes <- rbind(gemeentes,addition)
addition <- read.csv("data/standards/gemeentes/Limburg.csv")
gemeentes <- rbind(gemeentes,addition)

rm(addition)

# slice into regions "Oost", "West", "Zuid", "Noord"
# this slicing is based on the national standard
# http://www.regioatlas.nl/indelingen/indelingen_indeling/t/provincies

gemeentes$regio[gemeentes$provincie == "Noord-Holland"] <- "west"
gemeentes$regio[gemeentes$provincie == "Zuid-Holland"] <- "west"
gemeentes$regio[gemeentes$provincie == "Zeeland"] <- "west"
gemeentes$regio[gemeentes$provincie == "Utrecht"] <- "west"

gemeentes$regio[gemeentes$provincie == "Noord-Brabant"] <- "zuid"
gemeentes$regio[gemeentes$provincie == "Limburg"] <- "zuid"

gemeentes$regio[gemeentes$provincie == "Gelderland"] <- "oost"
gemeentes$regio[gemeentes$provincie == "Overijssel"] <- "oost"

gemeentes$regio[gemeentes$provincie == "Friesland"] <- "noord"
gemeentes$regio[gemeentes$provincie == "Drenthe"] <- "noord"
gemeentes$regio[gemeentes$provincie == "Groningen"] <- "noord"

write.table(gemeentes, "data/constructs/csv/gemeentes1.csv", sep = ",", row.names=FALSE)

# add regio2
no <- read.csv("data/standards/gemeentes/noordoost.csv")
nw <- read.csv("data/standards/gemeentes/noordwest.csv")
zo <- read.csv("data/standards/gemeentes/zuidoost.csv")
zw <- read.csv("data/standards/gemeentes/zuidwest.csv")

no$regio2 <- "noordoost"
nw$regio2 <- "noordwest"
zo$regio2 <- "zuidoost"
zw$regio2 <- "zuidwest"

regio2 <- rbind(no,nw,zo,zw)
rm(no)
rm(nw)
rm(zo)
rm(zw)

# merge regio and regio2
gemeentes <- merge(gemeentes, regio2, by.x = "amco", by.y = "acode", all.x = TRUE)
rm(regio2)

# write
write.table(gemeentes, "data/constructs/csv/gemeentes2.csv", sep = ",", row.names=FALSE)


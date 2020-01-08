# functieoverzicht
setwd("~/git/dwarsliggers/")
overzicht <- read.csv("data/sources/csv/personeelsoverzicht.csv")

locs <- overzicht[overzicht$afdeling == "Locomotieven",]
renw <- overzicht[overzicht$afdeling == "Rijtuigen en Wagens",]

# barplot voor locomotieven 
t <- locs$aantal_eind1902
names(t) <- locs$functiegroep
par(mar=c(5, 15, 3, 3))
barplot(t, 
        horiz = TRUE, 
        las = 1,
        xlim= c(0,250),
        xlab = "Aantal werklieden op de afdeling 'Locomotieven', naar functiegroep" 
)

# barplot voor rijtuigen en wagens
t <- renw$aantal_eind1902
names(t) <- renw$functiegroep
par(mar=c(5, 15, 3, 3))
barplot(t, 
        horiz = TRUE, 
        las = 1,
        xlim= c(0,250),
        xlab = "Aantal werklieden op de afdeling 'Rijtuigen en Wagens', naar functiegroep" 
)


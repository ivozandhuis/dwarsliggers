setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

overlap <- read.csv("data/constructs/csv/overlap.csv")
df_klein <- subset(df, select = c(my_medewerkersnummer, kleur))

overlap <- merge(overlap, df_klein, by.x = "medewerkera", by.y = "my_medewerkersnummer")
overlap <- merge(overlap, df_klein, by.x = "medewerkerb", by.y = "my_medewerkersnummer")

overlap$stakenbeiden <- TRUE
overlap$stakenbeiden[overlap$kleur.x == 'b' | overlap$kleur.y == 'b'] <- FALSE

overlap$staakgedraggelijk <- overlap$stakenbeiden
overlap$staakgedraggelijk[overlap$kleur.x == 'b' & overlap$kleur.y == 'b'] <- TRUE

overlap$houdenbeidenvol[overlap$kleur.x == 'w' | overlap$kleur.y == 'w'] <- FALSE
overlap$houdenbeidenvol[overlap$kleur.x != 'w' & overlap$kleur.y != 'w'] <- TRUE
overlap$houdenbeidenvol[!(overlap$stakenbeiden)] <- NA

overlap$volhoudgedraggelijk <- overlap$houdenbeidenvol
overlap$volhoudgedraggelijk[overlap$kleur.x == 'w' & overlap$kleur.y == 'w'] <- TRUE


# analyze
# select overlap > ?? meter
toAnalyze <- overlap[overlap$overlap > 1000,]

fit1 <- glm(toAnalyze$staakgedraggelijk ~ toAnalyze$overlap, family = binomial)
summary(fit1)
odds_fit1 <- as.data.frame(round(exp(cbind(OR = coef(fit1))),2))
odds_fit1

fit2 <- glm(toAnalyze$volhoudgedraggelijk ~ toAnalyze$overlap, family = binomial)
summary(fit2)
odds_fit2 <- as.data.frame(round(exp(cbind(OR = coef(fit2))),2))
odds_fit2


setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

# Q: Does workshop (werkplaats) matters?
# cross table
cross <- table(df$werkplaats, df$staker)
cross
prop.table(cross, 1)
addmargins(cross)
chi2 <- chisq.test(cross)
chi2
sqrt(chi2$statistic / sum(cross))

# A: yes.

#####
# Q: is de omvang van de werkplaats relevant?
# de hoeveelheid stakers moet dan naar mate het aantal werklieden op een werkplaats relatief toenemen.

cross2 <- table(df$werkplaats) # maak totalen
tabel <- as.data.frame(cbind(cross2, cross))
tabel$propT <- tabel$'TRUE'/tabel$cross2 # bereken verhouding aan stakers ten opzichte van het geheel

# knikker 2 werkplaatsen groter dan 100 personen er uit. Deze zouden de ijn teveel beinvloeden
# werkplaatsen met < 5 werklieden zijn te klein om van groepswerking te kunnen spreken
tabel <- tabel[tabel$cross2 < 100,]

# vind een lineair model
lmfit <- lm(tabel$propT ~ tabel$cross2)
summary(lmfit)

# plotten
plot(tabel$propT ~ tabel$cross2, xlab="omvang van de werkplaats (in aantal personen)", ylab="percentage stakers")
abline(lmfit)

# A: nee

############
# Q: welke werkplaats is het meest stakingsgevoelig?

# regressie analyse
## Locomotiefbankwerkerij (7e werkplaats in alfabetische volgorde) is referentie
df <- within(df, werkplaats <- relevel(werkplaats, ref = 4))
glmfit <- glm(staker ~ werkplaats, data = df, family = binomial)
summary(glmfit)

# check wat?? Of werkplaats er toe doet? Dat had ik al gedaan...
# variantie analyse
anova(glmfit)

# odd ratio's
glmfit.odds <- as.data.frame(round(exp(cbind(OR = coef(glmfit))),2))
glmfit.odds

# A: smederijen, rijtuigbankwerkerij, zadelmakerij, zeilmakerij

#########
# Q: welke werkplaats/HISCO-cominatie is het meest stakingsgevoelig?
# regressie analyse
df$werkplaatsHISCO <- paste(df$werkplaats, df$HISCO, sep = "")
df$werkplaatsHISCO <- as.factor(df$werkplaatsHISCO)

cross3 <- table(df$werkplaatsHISCO, df$staker)
cross4 <- table(df$werkplaatsHISCO)
tabel <- as.data.frame(cbind(cross4, cross3))

## Locomotiefbankwerkerij83210 (12e in alfabetische volgorde) is referentie

df <- within(df, werkplaatsHISCO <- relevel(werkplaatsHISCO, ref = 12))
glmfit2 <- glm(staker ~ werkplaatsHISCO, data = df, family = binomial)
summary(glmfit2)

# check wat?? Of werkplaats er toe doet? Dat had ik al gedaan...
# variantie analyse
anova(glmfit2)

# odd ratio's
glmfit2.odds <- as.data.frame(round(exp(cbind(OR = coef(glmfit2))),2))
glmfit2.odds

werkplaatsHISCO.table <- cbind(tabel,glmfit2.odds)
werkplaatsHISCO.table <- werkplaatsHISCO.table[cross4 > 5,]
werkplaatsHISCO.table <- werkplaatsHISCO.table[werkplaatsHISCO.table$'TRUE' > 0,]
werkplaatsHISCO.table <- werkplaatsHISCO.table[werkplaatsHISCO.table$'FALSE' > 0,]

write.table(werkplaatsHISCO.table, sep = "\t")

# LM ipv GLM??
# met lm kun je logit niet afdwingen?
lmfit <- lm(staker ~ werkplaats, data = df)
summary(lmfit)

anova(lmfit)


# Binomiale Logistische Regressie
# model_blauw:  staken (Y/n), voor allemaal

setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

# te kleine groepen verwijderen
toAnalyze <- df
toAnalyze <- toAnalyze[!(toAnalyze$HISCLASS == "6"),]
toAnalyze <- toAnalyze[!(toAnalyze$regio == "buitenland"),]
toAnalyze <- droplevels(toAnalyze)

# referenties bepalen
toAnalyze <- within(toAnalyze, regio <- relevel(regio, ref = 1)) # haarlem_eo
toAnalyze <- within(toAnalyze, geloof <- relevel(geloof, ref = 2)) # nh
toAnalyze <- within(toAnalyze, HISCLASS <- relevel(HISCLASS, ref = 1)) # 7

################################
################################

# creating formulas
# play with the variables by commenting out stuff you want to leave out
 formula <-  toAnalyze$staker ~ 
# formula <-  toAnalyze$volhouder ~ 
# formula <-  toAnalyze$ontslagen ~ 

   scale(toAnalyze$leeftijd) +
#   scale(toAnalyze$verantwoordelijkheid) +
#   scale(toAnalyze$aantal_dienstjaren) +
   toAnalyze$regio +
   toAnalyze$geloof +
   toAnalyze$HISCLASS +
   scale(toAnalyze$loon_intrapolatie)

# fitting model
# select staken, volhouden or ontslagen worden
#toAnalyze <- toAnalyze[!is.na(df$volhouder),]
#toAnalyze <- toAnalyze[!is.na(df$ontslagen),]

model <- glm(formula, family = binomial("logit"))
odds_model <- as.data.frame(round(exp(cbind(model = coef(model))),2))

# test models
summary(model, corr=TRUE)
anova(model, test="Chisq")
logLik(model)

# install.packages("fmsb")
library(fmsb)
NagelkerkeR2(model)

# view models
summary(model)
odds_model


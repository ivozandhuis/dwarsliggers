setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

# Leeftijd bij indiensttreding
count1 <- table(round(df$leeftijd)-round(df$aantal_dienstjaren))
count1
barplot(count1, las=2)

##############
# Year-cohort year of birth
##############

# number of men also working in 1903 per year 
df_stakers <- df[1903-round(df$leeftijd) > 1855,]
df_stakers <- df_stakers[1903-round(df_stakers$leeftijd) < 1887,]
count2 <- table(1903-round(df_stakers$leeftijd))
count2

# number of striking men per year in dataset
df_stakers <- df[df$staker,]
df_stakers <- df_stakers[1903-round(df_stakers$leeftijd) > 1855,]
df_stakers <- df_stakers[1903-round(df_stakers$leeftijd) < 1887,]
count4 <- table(1903-round(df_stakers$leeftijd))
count4

# ratio striking men working men per year-cohort
count6 = count4 / count2
barplot(count6, las=2, ylim = c(0,1))
m = mean(count6)
abline(h = .6)


##############
# Year-cohort indiensttreding
##############
# number of men also working in 1903 per year 
df_stakers <- df[1903-round(df$aantal_dienstjaren) > 1877,]
count2 <- table(1903-round(df_stakers$aantal_dienstjaren))
count2

# number of striking men per year in dataset
df_stakers <- df[df$staker,]
df_stakers <- df_stakers[1903-round(df_stakers$aantal_dienstjaren) > 1877,]
count4 <- table(1903-round(df_stakers$aantal_dienstjaren))
count4

# ratio striking men working men per year-cohort
count6 = count4 / count2
barplot(count6, las=2, ylim = c(0,1))
m = mean(count6)
abline(h = .6)

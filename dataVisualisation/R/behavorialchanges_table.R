setwd("~/git/dwarsliggers/")
source("dataTransformation/R/combineSources.R")

table(df$t0)
table(df$t1)
table(df$t2)
table(df$t3)
table(df$t4)
table(df$t5)

table(df[df$t0 != df$t1,]$t0)
table(df[df$t1 != df$t2,]$t1)
table(df[df$t2 != df$t3,]$t2)
table(df[df$t3 != df$t4,]$t3)
table(df[df$t4 != df$t5,]$t4)

table(df$aantal_wisselingen)


overlap <- read.csv("data/constructs/csv/overlap.csv")

# for some odd reason three employees have multiple routes; remove double combinations
overlap$double <- duplicated(overlap[,1:2]) 
overlap <- overlap[!overlap$double,]
overlap$double <- NULL

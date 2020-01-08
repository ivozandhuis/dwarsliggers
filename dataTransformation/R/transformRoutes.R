routes <- read.csv("data/constructs/csv/routes.csv")
names(routes)[1] <- "my_medewerkersnummer"

# for some odd reason three employees have multiple routes; remove 
routes$double <- duplicated(routes$my_medewerkersnummer)
routes <- routes[!routes$double,]
routes$double <- NULL

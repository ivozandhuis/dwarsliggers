# prepare libs for using Dwarsliggers Dataset

# use R version 3.6


# install hisco
install.packages("devtools")
library(devtools)
install_github("junkka/hisco")

# install Graph-stuff
install.packages("statnet")
install.packages("intergraph") # installs igraph as well)
install.packages("rgexf")

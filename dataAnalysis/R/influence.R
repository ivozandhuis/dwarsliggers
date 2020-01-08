setwd("~/git/dwarsliggers/")
source("dataTransformation/R/constructGraphs.R")

# g <- delete_vertices(tot_grp, which(degree(tot_grp) < 1))
g <- tot_grp

# halfkappa
# plot
dens1 <- density(V(g)[V(g)$staker]$powerhalfkappa)
dens2 <- density(V(g)[!(V(g)$staker)]$powerhalfkappa)
mean1 <- mean(V(g)[V(g)$staker]$powerhalfkappa)
mean2 <- mean(V(g)[!(V(g)$staker)]$powerhalfkappa)

plot(dens1, col="red", main="", xlab="Powercentrality")
lines(dens2, col="blue")

# is the difference in mean powercentrality of striking and non-striking employees significant?
wilcox.test(V(g)$powerhalfkappa ~ V(g)$staker)

# changing mean during the week
# t0
dens1 <- density(V(g)[V(g)$t0]$powerhalfkappa)
dens2 <- density(V(g)[!(V(g)$t0)]$powerhalfkappa)
plot(dens1, col="red", xlim=c(0, 8), ylim=c(0,1))
lines(dens2, col="blue")

mean1 <- mean(V(g)[V(g)$t0]$powerhalfkappa)
mean2 <- mean(V(g)[!(V(g)$t0)]$powerhalfkappa)

wilcox.test(V(g)$powerhalfkappa ~ V(g)$t0)

# t1
dens1 <- density(V(g)[V(g)$t1]$powerhalfkappa)
dens2 <- density(V(g)[!(V(g)$t1)]$powerhalfkappa)
plot(dens1, col="red", xlim=c(0, 8), ylim=c(0,1))
lines(dens2, col="blue")

mean1 <- mean(V(g)[V(g)$t1]$powerhalfkappa)
mean2 <- mean(V(g)[!(V(g)$t1)]$powerhalfkappa)

wilcox.test(V(g)$powerhalfkappa ~ V(g)$t1)

# t2
dens1 <- density(V(g)[V(g)$t2]$powerhalfkappa)
dens2 <- density(V(g)[!(V(g)$t2)]$powerhalfkappa)
plot(dens1, col="red", xlim=c(0, 8), ylim=c(0,1))
lines(dens2, col="blue")

mean1 <- mean(V(g)[V(g)$t2]$powerhalfkappa)
mean2 <- mean(V(g)[!(V(g)$t2)]$powerhalfkappa)

wilcox.test(V(g)$powerhalfkappa ~ V(g)$t2)

# t3
dens1 <- density(V(g)[V(g)$t3]$powerhalfkappa)
dens2 <- density(V(g)[!(V(g)$t3)]$powerhalfkappa)
plot(dens1, col="red", xlim=c(0, 8), ylim=c(0,1))
lines(dens2, col="blue")

mean1 <- mean(V(g)[V(g)$t3]$powerhalfkappa)
mean2 <- mean(V(g)[!(V(g)$t3)]$powerhalfkappa)

wilcox.test(V(g)$powerhalfkappa ~ V(g)$t3)

# t4
dens1 <- density(V(g)[V(g)$t4]$powerhalfkappa)
dens2 <- density(V(g)[!(V(g)$t4)]$powerhalfkappa)
plot(dens1, col="red", xlim=c(0, 8), ylim=c(0,1))
lines(dens2, col="blue")

mean1 <- mean(V(g)[V(g)$t4]$powerhalfkappa)
mean2 <- mean(V(g)[!(V(g)$t4)]$powerhalfkappa)

wilcox.test(V(g)$powerhalfkappa ~ V(g)$t4)

# t5
dens1 <- density(V(g)[V(g)$t5]$powerhalfkappa)
dens2 <- density(V(g)[!(V(g)$t5)]$powerhalfkappa)
plot(dens1, col="red", xlim=c(0, 8), ylim=c(0,1))
lines(dens2, col="blue")

mean1 <- mean(V(g)[V(g)$t5]$powerhalfkappa)
mean2 <- mean(V(g)[!(V(g)$t5)]$powerhalfkappa)

wilcox.test(V(g)$powerhalfkappa ~ V(g)$t5)




rm(list = ls())
par(mfrow = c(1,1))
set.seed(123)
setwd(sprintf("%s%s", "C:\\Users\\Bram\\Documents\\Google Drive\\",
              "Uni\\Statistical Data Analysis\\Assignment 9"))
source("functions_Ch4.txt")
source("functions_Ch6.txt")

### Exercise 1
## A
wilco_stat = function(X, m0 = 0) {
  V = 0
  for (i in 1 : length(X)) {
    V = V + rank(abs(X - m0))[i] * sign(X[i] - m0)
  }
  V
}
sign_stat = function(X, m0 = 0) {
  sum(X > m0)
}

## B
n = 200
for (th in c(0, .05, .1, .15)) {
  wilco_rejects = 0
  sign_rejects = 0
  for (i in 1 : 1000) {
    X = runif(n, min = -1 + th, max = 1 + th)
    V = wilco_stat(X)
    wilco_rejects = wilco_rejects + (V > 1.644854*sqrt(n*(n+1)*(2*n+1)/6))
    S = sign_stat(X)
    sign_rejects = sign_rejects + (S > 1.544854*sqrt(n)/2+n/2)
  }
  print("Line order: theta, Wilco rejects, sign rejects")
  print(th)
  print(wilco_rejects)
  print(sign_rejects)
}

## D
# Using table from part (B) but extended with theta's 0.20 and 0.25.
v=seq(0,0.30,0.05)
v1= c(0,54,320,768,962,998,1000)
v2=c(0,56,180,414,690,899,984)
plot(v1,v)
plot(v2,v)

### Exercise 2
## A
nc = scan("newcomb.txt")
nc_first20 = nc[1:20]; nc_last46 = nc[21:length(nc)]
p1 <- hist(nc_first20, breaks=seq(-60, 60, 5), plot=F)
p2 <- hist(nc_last46, breaks=seq(-60, 60, 5), plot=F)
p1$counts = p1$counts / sum(p1$counts)
p2$counts = p2$counts / sum(p2$counts)
plot(p1, col=rgb(0,0,1,1/4), 
     main="Blue for first 20,\nred for last 46", 
     xlab="Measurement of time delta in s",
     ylim=c(0,.5), ylab="Density")
plot(p2, col=rgb(1,0,0,1/4), add=T)
mean(nc_first20); mean(nc_last46)
boxplot(nc_first20, nc_last46)
# In any case, the underlying distributions are probably continuous, 
# and the measurements iid.

x = nc_first20; y = nc_last46
data = c(x, y)
t = sum(x <= median(data))
nx = length(x); ny = length(y)
1 - phyper(t-1, nx, ny, floor(nx+ny+1)/2) # p = 0.26
wilcox.test(x, y) # p = 0.12
ks.test(x, y) # p = 0.33

## B
# Probably want a robust estimator with the outliers.
meas <- function(data) {
  mean(data, trim = .2)
}
meas(nc)
bs1 = bootstrap(nc, meas, B=1000); bs2 = meas(nc)
c(bs2-quantile(bs1-bs2, probs=.975), bs2-quantile(bs1-bs2, probs=.025))
# Get 26.15000 28.62563 
# Expect 24.83 to not be in given this data.
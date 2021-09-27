## Lecture 1

setwd("C:/Users/Dennis/surfdrive/Documents/VU Amsterdam/Lectures/2019 SDA/Lectures/Lecture 1")
# dataframe...
data <- read.table("fishcatch.dat.txt")
# vector...
data <- scan("fishcatch.dat.txt")
# alternatively, button "Import Dataset"


X <- rnorm(n=100, mean=0, sd=1)
X <- rnorm(100,0,1)

summary(X)
boxplot(X)
hist(X, freq = FALSE)


library(mvtnorm)

XY <- rmvnorm(100, mean = c(1,-2), sigma = matrix(c(1,0, 0, 1), 2, 2))
plot(XY)

XY <- rmvnorm(100, mean = c(1,-2), sigma = matrix(c(1,0.8, 0.8, 1), 2, 2))
plot(XY)

plot(ecdf(X), xlim=c(-3,3), ylim=c(0,1))
par(new=TRUE)
x <- seq(-2,2,0.001)
plot(x, pnorm(x), col=2, type="l", xlim=c(-3,3), ylim=c(0,1))

stem(X)



library(aplpack)
class <- data.frame(sex = rbinom(n=20, size=1, prob=0.5), height = numeric(20), weight = numeric(20))
class$height <- rnorm(20, mean=165 + 5*class$sex, sd=4)
class$weight <- rnorm(20, mean = 22, sd=2) * (class$height/100)^2
faces(class)



## Lecture 2

f_hist_dens<-function(z){
  n <- length(z)
  hist(z,prob=T,xlim=c(0,15),ylim=c(0,1.5 * dchisq(mean(z), df=4)), 
       main=paste("Histogram of ", n, " observations"))
  u <- seq(0,15,0.01)
  lines(u,dchisq(u,df),col="red",lwd=2)
  legend("topright", legend=paste("density chisq(", df, ")"), col=2, lty=1)
}

set.seed(12345)
n <- 100
df <- 4
x <- rchisq(n,df)

par(mfrow=c(1,2))
f_hist_dens(x)

n <- 1000
df <- 4
x <- rchisq(n,df)
f_hist_dens(x)


set.seed(12345)
L <- list(rnorm(100,0,1), rnorm(200, mean=1, sd=2), rnorm(200))
par(mfrow=c(1,1))
boxplot(L, main="boxplots", xlab="sample number")
lapply(L, summary)

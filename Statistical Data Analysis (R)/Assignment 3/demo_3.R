## After Lecture 1

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



## After Lecture 2

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



## After Lecture 3

setwd("C:/Users/Dennis/surfdrive/Documents/VU Amsterdam/Lectures/2019 SDA/Assignments/2019/Assignment 2")
source("functions_Ch3.txt")

a=seq(0.01,0.99,length=1000)
plot(x=qcauchy(a), y=qnorm(a), type="l",ylab="quantiles N(0,1)",   xlab="quantiles Cauchy", main="True Q-Q plot")

sample <- rnorm(100,0,1)
qqnorm(sample, main="Normal Q-Q Plot, n=100")
qqline(sample, col=2)
abline(a=mean(sample) - sd(sample) / 1 * 0, sd(sample) / 1, col=2)
symplot(sample)

qqchisq(sample, df=5, main="chisq_5 Q-Q Plot, n=100")
qqline(sample, distribution = function(x,df=5) qchisq(x,df), col="red")

qqplot(x = rnorm(200), y = rnorm(200, 2, 7))

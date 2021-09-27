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

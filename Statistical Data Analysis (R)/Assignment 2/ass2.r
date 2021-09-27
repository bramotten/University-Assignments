setwd("C:\\Users\\Bram\\Documents\\Google Drive\\Uni\\Statistical Data Analysis\\Assignment 2")

### Exercise 2.1
## A
par(mfrow=c(2,2))
aRange = seq(0.01,0.99,.01)

x = qcauchy(aRange)
y = qnorm(aRange)
plot(x,y, type="l", main="Standard Cauchy dist. -- standard normal dist.", ylab="Cauchy quantiles", 
     xlab="Standard normal quantiles")

y = qt(aRange, 4)
x = qnorm(aRange)
plot(x,y, type="l", main="Standard normal dist. --\nt dist. with 4 DOF", xlab="t dist. with 4 DOF quantiles", 
     ylab="Standard normal quantiles")

y = qlnorm(aRange, sdlog=.5)
x = qunif(aRange, min=2, max=4)
plot(x,y, type="l", main="Uniform dist. (min. 2 and max. 4) --\nlog normal dist. with mean 0 and std .5",
     xlab="Uniform dist. (min. 2 and max. 4) quantiles", ylab="log normal dist. with mean 0 and std .5 quantiles")

# TODO: check, label, comment on tails etc.,

## B is trivial

## C
par(mfrow=c(1,1))
source("./functions_Ch3.txt")
sample_data = scan("sample2019.txt")
plot(sort(sample_data))

#qqlaplace(sample_data)
# qqcauchy(sample_data)
#sample_data = sort(sample_data)[1:length(sample_data) - 1] # mag vast niet
m = mean(sample_data); v = var(sample_data); z = 1 + v / (m * m)
mu = log(m / sqrt(z)); sd = log(z)
qqlnorm(sample_data, meanlog=mu, sdlog=sd); abline(m, sqrt(v))
qqnorm(sample_data)
qqexp(sample_data)
qqt(sample_data, df=1)

# TODO: vielleicht zijn er betere parameters, vast iets over schrijven

### Exercise 2.2
## A
par(mfrow=c(2,2))
source("./temp.txt")
plot(sort(temp$eelde), type="l", main="Eelde", xlab="Year since 1964",
     ylab="Mean temperature in July")
plot(sort(temp$terbeek), type="l", main="Terbeek", xlab="Year since 1964",
     ylab="Mean temperature in July")

qqnorm(sort(temp$eelde))
qqnorm(sort(temp$terbeek))
# TODO: hij zei iets over abline

# Now assume temp$terbeek = Y = a + b * X with X = N(0,1)
# E(X) = 0. E(Y) =
mean(temp$terbeek) # = 16.59 = a
var(temp$terbeek) # = 4.043
# Var(Y) = b^2 * Var(X)
sqrt(4.043) # = 2.01 = b
normalizedTB = sort((temp$terbeek) - 16.59) / sqrt(2.01)
qqnorm(normalizedTB); qqline(normalizedTB)
qqnorm(sort(temp$terbeek)) ; abline(mean(temp$terbeek), sqrt(var(temp$terbeek)))

r = mean(temp$terbeek)
w = var(temp$terbeek)
normalizedTerbeek = sort((temp$terbeek - r) / sqrt(w))
qqnorm(normalizedTerbeek); #qqline(normalizedTerbeek)
qqnorm(temp$terbeek); abline(r, sqrt(w))

# TODO: Eelde, C, en schrijven
hist(sort(temp$eelde) - sort(temp$terbeek))

par(mfrow=c(1,1))
y=unlist(sort(temp$eelde)) 
z=unlist(sort(temp$terbeek)) 
hist(z-y, prob=T) # TODO: miss dus met prob=T



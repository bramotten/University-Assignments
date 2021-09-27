## Initialization
rm(list=ls())
par(mfrow=c(1,1))
setwd("C:\\Users\\Bram\\Documents\\Google Drive\\Uni\\Statistical Data Analysis\\Assignment 4")
source("./functions_Ch3.txt")
source("./functions_Ch4.txt")

### Exercise 4.1
## A
library(moments) # provides skewness
g = scan("./gamma.txt")

## B
empBS = bootstrap(g, skewness, B=1000)

## C
mean(g) # = 12.66
var(g) # = 84.23
th = var(g) / mean(g) # 6.65
k = mean(g) / th # 1.90
parBS = replicate(1000, rgamma(n=length(g), shape=k, scale=th))

## D 
# Jim

## E
# Jim

### Exercise 4.2
## A
b = scan("./birthweight.txt")
par(mfrow=c(1,2))
hist(b); qqnorm(b) # looks ~ normal
shapiro.test(b) # p = .44, can't say it's not normal

## B 
var(bootstrap(b, median, B=1000)) # 4388.08

## C
meds = numeric(1000)
n = length(b); r = 1 / mean(b)
for (i in 1:1000) {
  meds[i] = median(rexp(n=n, rate=r))
}
var(meds) # 46602.83

## D
var(replicate(1000, median(rexp(n=n, rate=r))))


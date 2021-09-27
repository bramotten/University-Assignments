gctorture(FALSE)
rm(list=ls())
par(mfrow=c(1,1))
setwd("C:\\Users\\Bram\\Documents\\Google Drive\\Uni\\Statistical Data Analysis\\Assignment 5")
source("./functions_Ch3.txt")
source("./functions_Ch4.txt")

## Exercise 5.1
## A
source("./thromboglobulin.txt")
prrp = thromboglobulin$PRRP
B = 1000; alph = .05
# Suppose expectation = mean.
means = bootstrap(prrp, mean, B=B)
hist(means);
t = mean(prrp)
z = means - t
meanC = c(t-quantile(z, probs=1-alph/2), t-quantile(z, probs=alph/2))
meanC # [51.45, 71.08]

## B
medians = bootstrap(prrp, median, B=B)
hist(medians)
t2 = median(prrp)
z2 = medians - t2;
mediC = c(t2-quantile(z2, probs=1-alph/2), t2-quantile(z2, probs=alph/2))
mediC # [40.00, 64.00]

## C
hist(prrp, prob=TRUE, xlim=c(0,150), main="Histogram of PPRP, 95% confidence interval\nof means between blue lines\nof medians between red lines")
abline(v=meanC[1], col="blue")
abline(v=meanC[2], col="blue")
abline(v=mediC[1], col="red")
abline(v=mediC[2], col="red")
mean(prrp); sd(prrp)

## D
sdrp = thromboglobulin$SDRP
diffs = numeric(B)
for (i in 1:B) {
  diffs[i] = mean(sample(prrp, replace=TRUE)) -
      mean(sample(sdrp, replace=TRUE)) - (mean(prrp) - mean(sdrp))
}
hist(diffs)
diffC = c(quantile(diffs, probs=alph/2), quantile(diffs, probs=1-alph/2))
diffC # [-16.36, 15.13]

## Exercise 5.2
## A
n = 50; X = runif(n, 0, 1)
B = 1000
EmpBS = numeric(B);
for (i in 1: B) {
  xstar = sample(X, replace = TRUE)
  EmpBS[i] = ((n + 1) / n) * max(xstar)
}
var(EmpBS)
sd(EmpBS)

## B
sdevs = numeric(100)
for (j in 1:100) {
  n = 50; X = runif(n, 0, 1)
  B = 1000
  EmpBS = numeric(B);
  for (i in 1: B) {
    xstar = sample(X, replace = TRUE)
    EmpBS[i] = ((n + 1) / n) * max(xstar)
  }
  sdevs[j] = sd(EmpBS)
}
mean(sdevs) # 0.0209127
sd(sdevs) # 0.01150859

## C

X = runif(50,0,1)
B = 1000
theta = (50+1)/50*max(X)
ParBS = numeric(B);
for (i in 1: B)
{
 xstar = runif(length(X), 0,theta)
 ParBS[i] = ((n+1)/(n))*max((xstar))
}
var(ParBS)
sd(parBS)

sdevs = numeric(100)
for (j in 1:100) {
  X = runif(50,0,1)
  B = 1000
  theta = (50+1)/50*max(X)
  ParBS = numeric(B)
  for (i in 1: B)
  {
    xstar = runif(length(X), 0,theta)
    ParBS[i] = ((n+1)/(n))*max((xstar))
  }
  sdevs[j] = sd(ParBS)
}
mean(sdevs)
sd(sdevs)

## D

m = 100
Xpar = numeric(m)
for (j in 1: m)
{
 X=runif(50,0,1)

 B=1000
 theta = ((50+2)/(50+1))*max(X)
 ParBS = numeric(B);
 for (i in 1: B)
 {
   xstar = runif(length(X), 0, theta)
   ParBS[i] = ((n + 1) / n) * max((xstar))
 }
 Xpar[j] = sd(ParBS)
}
mean(Xpar)
sd(Xpar)

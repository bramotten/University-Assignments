gctorture(FALSE)
rm(list=ls())
par(mfrow=c(1,1))
setwd("C:\\Users\\Bram\\Documents\\Google Drive\\Uni\\Statistical Data Analysis\\Assignment 6")
source("./functions_Ch4.txt")

### Exercise 1
## B
source("light.txt")
light79 = light$'1879'; n79 = length(light79)
m79 = mean(light79)
s79 = 0
for (i in 1:length(light79)) {
  s79 = s79 + (light79[i] - m79) ^ 2
}
s79 = sqrt(s79 / (n79-1))
B = 1000
# MOET MET DE HAND!
bs = bootstrap(light79, ks.test, B = B, m79, s79)
bsVec = numeric(length(bs))
for (i in 1:length(bs)) {
  bsVec[i] = bs[[i]]
}
hist(bsVec); mean(bsVec); sd(bsVec)

light82 = light$'1882'; n82 = length(light82)
m82 = mean(light82)
s82 = 0
for (i in 1:length(light82)) {
  s82 = s82 + (light82[i] - m82) ^ 2
}
s82 = sqrt(s82 / (n82-1))
B = 1000

bs = bootstrap(light82, ks.test, B = B, m82, s82)
bsVec = numeric(length(bs))
for (i in 1:length(bs)) {
  bsVec[i] = bs[[i]]
}
hist(bsVec); mean(bsVec); sd(bsVec)

## C
ks.test(light79, pnorm, m79, s79)
ks.test(light82, pnorm, m82, s82)

### Exercise 2
## C
source("lepton.txt")
boxplot(lepton, ylim=c(0,100))

## D
# Probably zoiets als het volgende, D = b1 - (som van de rest)
t = .2; alph=.02
c = mean(lepton$B1, trim=t) -
  (mean(lepton$Bmu, trim=t) + mean(lepton$Be, trim=t) +
   mean(lepton$Bpi, trim=t) + mean(lepton$Brho, trim=t))
c = 0
diffs = numeric(B)
for (i in 1:B) {
  diffs[i] = mean(sample(lepton$B1, replace=TRUE), trim=t) -
    (mean(sample(lepton$Bmu, replace=TRUE), trim=t) +
     mean(sample(lepton$Be, replace=TRUE), trim=t) +
     mean(sample(lepton$Bpi, replace=TRUE), trim=t) +
     mean(sample(lepton$Brho, replace=TRUE), trim=t)) - c
}
hist(diffs)
diffC = c(quantile(diffs, probs=alph/2), quantile(diffs, probs=1-alph/2))
diffC # moet met t ~ .5 en alph = .02 ongeveer [15, 21] zijn.

## E
t = 0

setwd("C:\\Users\\Jim\\Documents\\Rscripts")
gctorture(FALSE)
rm(list=ls())
par(mfrow=c(2,2))
setwd("C:\\Users\\Bram\\Documents\\Google Drive\\Uni\\Statistical Data Analysis\\Assignment 6")
source("./light.txt")
source("./functions_Ch4.txt")
source("./lepton.txt")
set.seed(123)

### Exercise 6.1
## B
# Parametric 79
light79 = sort(light$`1879`)
m79 = mean(light79)
s79 = sd(light79)
B = 1000
n79 = length(light79)
EmpBS79= numeric(B);
EmpBS79p= numeric(B); # don't take this seriously
for (i in 1:B)
{
  xstar = sample(light79, n79, replace=T)
  EmpBS79[i] = ks.test(xstar, pnorm, m79 , s79)$statistic
  EmpBS79p[i] = ks.test(xstar, pnorm, m79 , s79)$p.value
}
hist(EmpBS79)
d79 = mean(EmpBS79); d79 # 0.12
d79 * sqrt(n79) # 1.17
l79 = .870612 # https://projecteuclid.org/download/pdf_1/euclid.aoms/1177730256
p79 = 1 - l79; p79 # 0.13
hist(EmpBS79p)

# Parametric 82
light82 = sort(light$`1882`)
m82 = mean(light82)
s82 = sd(light82)
B = 1000
n82 = length(light82)
EmpBS82= numeric(B);
EmpBS82p= numeric(B); # don't take this seriously
for (i in 1:B)
{
  xstar = sample(light82, n82, replace = T)
  EmpBS82[i] = ks.test(xstar, pnorm, m82 , s82)$statistic
  EmpBS82p[i] = ks.test(xstar, pnorm, m82 , s82)$p.value
}
hist(EmpBS82)
d82 = mean(EmpBS82); d82 # 0.22
d82 * sqrt(n82) # 2.23
l82 = .999904 # https://projecteuclid.org/download/pdf_1/euclid.aoms/1177730256
p82 = 1 - l82; p82 # 9.6e-5
hist(EmpBS82p)

## C
ks.test(light79, pnorm, m79, s79) # 0.083, p = 0.49
ks.test(light82, pnorm, m82, s82) # 0.145, p = 0.72

### Exercise 6.2
## B
alph=.02; t=.25
# TODO: hoe kom je hieraan? Want Dut != 18.25
c(qnorm(alph/2, 18.25, 1.22), qnorm(1-alph/2, 18.25, 1.22))

## C
par(mfrow=c(1,1))
boxplot(lepton, ylim=c(0,100))

## D
t = .2
B1 = lepton$B1
Bmu = lepton$Bmu
Be = lepton$Be
Bpi = lepton$Bpi
Brho = lepton$Brho
Dut = mean(B1, trim=t) - (mean(Bmu, trim=t) + mean(Be, trim=t) +
      mean(Bpi, trim=t) + mean(Brho, trim=t))

meansBS = numeric(B)
for (i in 1:B) {
  meansBS[i] = mean(sample(lepton$B1, replace=TRUE), trim=t) -
               (mean(sample(lepton$Bmu, replace=TRUE), trim=t) +
                mean(sample(lepton$Be, replace=TRUE), trim=t) +
                mean(sample(lepton$Bpi, replace=TRUE), trim=t) +
                mean(sample(lepton$Brho, replace=TRUE), trim=t))
}
hist(meansBS)
z = meansBS-Dut
meansC = c(Dut-quantile(z, probs=1-alph/2), Dut-quantile(z, probs=alph/2))
meansC # [14.05, 19.48]

## E
Du = mean(B1) - (mean(Bmu) + mean(Be) + mean(Bpi) + mean(Brho))
meansBS = numeric(B)
for (i in 1:B) {
  meansBS[i] = mean(sample(lepton$B1, replace=TRUE), trim=t) -
    (mean(sample(lepton$Bmu, replace=TRUE), trim=t) +
       mean(sample(lepton$Be, replace=TRUE), trim=t) +
       mean(sample(lepton$Bpi, replace=TRUE), trim=t) +
       mean(sample(lepton$Brho, replace=TRUE), trim=t))
}
hist(meansBS)
z = meansBS-Du
meansC = c(Du-quantile(z, probs=1-alph/2), Du-quantile(z, probs=alph/2))
meansC # [13.18, 18.02]

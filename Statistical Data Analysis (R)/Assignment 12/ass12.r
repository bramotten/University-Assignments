rm(list = ls())
par(mfrow = c(1, 2))
set.seed(123)
setwd(
  sprintf(
    "%s%s",
    "C:\\Users\\Bram\\Documents\\Google Drive\\",
    "Uni\\Statistical Data Analysis\\Assignment 12"
  )
)

source("functions_Ch8.txt")

### Exercise 1
geese <- read.table("geese.txt", header = T)
## A
pairs(geese) # looks okay for lin reg.
## B
lmpo1 <- lm(formula = observer1 ~ photo, data = geese)
lmpo2 <- lm(formula = observer.2 ~ photo, data = geese)
summary(lmpo1)
summary(lmpo2)
# Both B_1s != 0 with very low p.
## C
plot(residuals(lmpo1), geese$observer1)
abline(v = 0)
plot(residuals(lmpo2), geese$observer.2)
abline(v = 0)
# Page 120 (125) indicates we should transform variables or use nonlinear model.
# (Assumption of equal variance of measurement errors not met.)
## D
qqnorm(residuals(lmpo1))
qqnorm(residuals(lmpo2))
ks1 <- lm.norm.test(geese$photo, geese$observer1)
ks2 <- lm.norm.test(geese$photo, geese$observer.2)
sgeese1 <- summary(lmpo1)[[6]]
sgeese2 <- summary(lmpo2)[[6]]
resgeese1 <- residuals(lmpo1)
resgeese2 <- residuals(lmpo2)
D1 <- ks.test(resgeese1, pnorm, 0., sgeese1)[[1]]
D2 <- ks.test(resgeese2, pnorm, 0., sgeese2)[[1]]
mean(ks1 > D1)
mean(ks2 > D2)
## E
lgeese <- log(geese)
pairs(lgeese)
llmpo1 <- lm(formula = observer1 ~ photo, data = lgeese)
llmpo2 <- lm(formula = observer.2 ~ photo, data = lgeese)
summary(llmpo1)
summary(llmpo2)
plot(residuals(llmpo1), lgeese$observer1)
abline(v = 0)
plot(residuals(llmpo2), lgeese$observer.2)
abline(v = 0)
qqnorm(residuals(llmpo1))
qqnorm(residuals(llmpo2))
lks1 <- lm.norm.test(lgeese$photo, lgeese$observer1)
lks2 <- lm.norm.test(lgeese$photo, lgeese$observer.2)
lsgeese1 <- summary(llmpo1)[[6]]
lsgeese2 <- summary(llmpo2)[[6]]
lresgeese1 <- residuals(llmpo1)
lresgeese2 <- residuals(llmpo2)
lD1 <- ks.test(lresgeese1, pnorm, 0., lsgeese1)[[1]]
lD2 <- ks.test(lresgeese2, pnorm, 0., lsgeese2)[[1]]
mean(lks1 > lD1)
mean(lks2 > lD2)
## F
# The log-transformed data is preferred in any case.
# Observer 1 obtains a lower R^2.
## G
# 1. The observers are pretty good, at least with a low # of birds.
# 2. Obs 1 is very slightly 'better-modellable/-consistent' than obs 2.

### Exercise 2
airpoll <- read.table("airpollution.txt", header = T)
## A
pairs(airpoll)
## B
aw <- lm(formula = oxidant ~ wind, data = airpoll)
at <- lm(formula = oxidant ~ temperature, data = airpoll)
ah <- lm(formula = oxidant ~ humidity, data = airpoll)
ai <- lm(formula = oxidant ~ insolation, data = airpoll)
summary(aw) # R^2 = 0.59, p = 8e-7
summary(at) # R^2 = 0.58, p = 1e-6
summary(ah) # R^2 = 0.12, p = 0.056
summary(ai) # R^2 = 0.25, p = 0.0044
# R^2 is something like 'fraction of explained variance', so add the best: wind.
awt <- lm(formula = oxidant ~ wind + temperature, data = airpoll)
awh <- lm(formula = oxidant ~ wind + humidity, data = airpoll)
awi <- lm(formula = oxidant ~ wind + insolation, data = airpoll)
summary(awt) # the best (and good enough)
summary(awh)
summary(awi)
awth <-
  lm(formula = oxidant ~ wind + temperature + humidity,
     data = airpoll)
awti <-
  lm(formula = oxidant ~ wind + temperature + insolation,
     data = airpoll)
summary(awt) # R^2 = 0.78, p = 1.56e-9
summary(awth) # R^2 = 0.80 (0.796), p = 3.9e-9
summary(awti) # R^2 = 0.78, p = 9.5e-9
# Just wind and T as independent vars looks good, not enough R^2 increase.
# (Seperate variables also get insignificant t-test p-values.)
# (Also similar residual standard error.)
## C
a <-
  lm(formula = oxidant ~ wind + temperature + humidity + insolation,
     data = airpoll)
summary(a) # coefficients espectively -0.44, 0.56, 0.093, 0.022
# R^2 = 0.80, residual standard error = 2.87, p = 2.28e-8.
# So yes, at least one of the variables should be included in the model.
## D
# Look at returned p-values. Insolation is highest:
summary(awth) # humidity's p is still > 0.05, so try
summary(awt) # which has all variables' p-values < 0.05
## E
# We ended up with model awt (wind and temperature) using both methods.
# Respective parameters: -0.42 and 0.52, with a -5.2 intercept.
# R^2 = 0.78, residual standard error = 2.95 (on 27 DOF), p = 1.56e-9.

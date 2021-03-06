rm(list = ls())
par(mfrow = c(1, 1))
set.seed(123)
setwd(
  sprintf(
    "%s%s",
    "C:\\Users\\Bram\\Documents\\Google Drive\\",
    "Uni\\Statistical Data Analysis\\Assignment 13"
  )
)

source("functions_Ch8.txt")

### Exercise 1
st <- read.table("steamtable.txt", header = T)
# Response: st$Steam

## A
pairs(st)
for (i in colnames(st)) {
  if (i != "Steam") {
    m = summary(lm(paste("Steam~", i[[1]]), data = st))
    print(i)
    print(m$r.squared)
  }
}
# Temperature as only explanatory variable causes the largest R^2.

## B
m <- lm(Steam ~ Temperature, st)
maxR2 <- 0
best <- 0
for (i in colnames(st)) {
  if (i != "Steam" && i != "Temperature") {
    m <- summary(lm(paste("Steam~Temperature+", i[[1]]), data = st))
    R2 <- m$r.squared
    if (R2 > maxR2) {
      best <- i
      maxR2 <- R2
    }
  }
}
best
summary(lm(Steam ~ Temperature + Fatty.Acid, st))
# Fatty.Acid, the next x that increases R^2 by most, is also significant.
m <- lm(Steam ~ Temperature + Fatty.Acid, st)
# Repeat.
maxR2 <- 0
best <- 0
for (i in colnames(st)) {
  if (i != "Steam" && i != "Temperature" && i != "Fatty.Acid") {
    mi <- summary(lm(paste("Steam~Temperature+", i[[1]]), data = st))
    R2 <- mi$r.squared
    if (R2 > maxR2) {
      best <- i
      maxR2 <- R2
    }
  }
}
best
summary(lm(Steam ~ Temperature + Fatty.Acid + Operating.Days, st))
# Operating.Days, the next best x, is not significant @ .05.
plot(st$Temperature, st$Steam)
plot(st$Fatty.Acid, st$Steam)
plot(st$Temperature, st$Fatty.Acid) # don't seem collinear visually.

## C (find influence points and collinearity)
sort(round(hatvalues(m), 3)) # i = 7 is greater than
2 * mean(hatvalues(m)) # , but not by much -- might be a leverage point.
sort(round(cooks.distance(m), 3)) # no values close to or over 1.
# Is trying without largest a good idea even if they're this low?
# Fatty.Acid and Temperature are variables 2 and 8
cor(st[, c(2, 8)]) # very small.
X1 = st[, 1] / sum(st[, 1])
X2 = st[, 2] / sum(st[, 2])
X = matrix(c(X1, X2), ncol = 2)

round(varianceinflation(X), 2) # none much > 1.
round(conditionindices(X), 2) # huge condition index. TODO: so?
round(vardecomposition(X), 2) # Temperature doesn't contribute much.
# TODO: so?

## D (investigate normality of residuals)
qqnorm(residuals(m))
plot(residuals(m), st$Steam)
abline(v = 0)
# TODO: weer zo'n bootstrap als
ks1 <- lm.norm.test(c(st$Fatty.Acid, st$Temperature), st$Steam)
sgeese1 <- summary(lmpo1)[[6]]
resgeese1 <- residuals(lmpo1)
D1 <- ks.test(resgeese1, pnorm, 0., sgeese1)[[1]]
mean(ks1 > D1)

## E (suitable model?)
# Yes?

### Exercise 2
ec <- read.table("expensescrime.txt", header = T)
ec_ori <- ec <- read.table("expensescrime.txt", header = T)
# Use ec$expend as response variable.
pairs(ec)

for (i in colnames(ec)) {
  if (i != 'state' && i != "expend") {
    m = summary(lm(paste("expend~", i[[1]]), data = ec))
    print(i)
    print(m$r.squared)
  }
}

# Employ causes largest R^2.
m = lm(expend ~ employ, data = ec)
summary(m)
# Discard intercept actually.
m = lm(expend ~ employ - 1, data = ec)
summary(m)
for (i in colnames(ec)) {
  if (i != 'state' && i != "expend" && i != 'employ') {
    m = summary(lm(paste("expend~employ+", i[[1]], "-1"), data = ec))
    print(i)
    print(m$r.squared)
  }
}

# Now lawyers.
m = lm(expend ~ employ + lawyers - 1, data = ec)
summary(m) # already looks like some collinearity.
for (i in colnames(ec)) {
  if (i != 'state' &&
      i != "expend" && i != 'employ' && i != "lawyers") {
    m = summary(lm(paste("expend~employ+lawyers+", i[[1]], "-1"), data = ec))
    print(i)
    print(m$r.squared)
  }
}

# Try crime.
m = lm(expend ~ employ + lawyers + crime - 1, data = ec)
summary(m)
# Actually kind of significant at 0.022.
for (i in colnames(ec)) {
  if (i != 'state' &&
      i != "expend" &&
      i != 'employ' && i != "lawyers" && i != 'crime') {
    m = summary(lm(paste(
      "expend~employ+lawyers+crime+", i[[1]], "-1"
    ), data = ec))
    print(i)
    print(m$r.squared)
  }
}

# bad.
m = lm(expend ~ employ + lawyers + crime + bad - 1, data = ec)
summary(m) # nope, stay with
m = lm(expend ~ employ + lawyers + crime - 1, data = ec)
summary(m)

# Influence points.
sort(round(hatvalues(m), 3))
2 * mean(hatvalues(m))
# indices 35 and 5 suck
sort(round(cooks.distance(m), 3))
# index 5 again
ec <- ec[-5,]
m = lm(expend ~ employ + lawyers + crime - 1, data = ec)
summary(m)
# Get rid of crime again.
m = lm(expend ~ employ + lawyers - 1, data = ec)
summary(m)
# Lose index 35.
ec <- ec[-34,]
m = lm(expend ~ employ + lawyers - 1, data = ec)
summary(m)

# Collinearity.
X1 = ec$employ / sum(ec$employ)
X2 = ec$lawyers / sum(ec$lawyers)
#X3 = ec$crime / sum(ec$crime)
X = matrix(c(X1, X2), ncol = 2)
cor(X) # very collinear

summary(lm(expend ~ bad + crime + lawyers + employ + pop - 1, data = ec))
# Maybe bad deserves another try.
summary(lm(expend ~ bad + employ - 1, data = ec))
summary(lm(expend ~ employ - 1, data = ec))
X1 = ec$employ / sum(ec$employ)
X2 = ec$bad / sum(ec$bad)
X = matrix(c(X1, X2), ncol = 2)
cor(X) # less collinear
m <- lm(expend ~ bad + employ - 1, data = ec)
sort(round(hatvalues(m), 3))
2 * mean(hatvalues(m))
sort(round(cooks.distance(m), 3))
# So only use employ, even top-down
m <- lm(expend ~ employ - 1, data = ec)
summary(m)
sort(round(hatvalues(m), 3))
2 * mean(hatvalues(m))
sort(round(cooks.distance(m), 3))
# No more really bad points, no collinearity.

qqnorm(residuals(m))
plot(residuals(m), ec$expend)
abline(v = 0)
# TODO: more bootstrap.

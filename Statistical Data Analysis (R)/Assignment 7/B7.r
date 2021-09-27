rm(list = ls())
par(mfrow = c(1,1))
set.seed(123)
setwd(sprintf("%s%s", "C:\\Users\\Bram\\Documents\\Google Drive\\",
              "Uni\\Statistical Data Analysis\\Assignment 7"))
source("functions_Ch4.txt")
source("functions_Ch5.txt")

### Exercise 1
## A
n = 1000
estimators <- list(tr00 = replicate(n, mean(rt(100, 4))),
                   tr10 = replicate(n, mean(rt(100, 4), .1)),
                   tr20 = replicate(n, mean(rt(100, 4), .2)),
                   tr30 = replicate(n, mean(rt(100, 4), .3)),
                   tr40 = replicate(n, mean(rt(100, 4), .4)),
                   tmed = replicate(n, median(rt(100, 4))),
                   tmlo = replicate(n, mlogis(rt(100, 4))),
                   tmhu = replicate(n, mhuber(rt(100, 4))))
means <- lapply(estimators, mean)
variances <- lapply(estimators, var)
mse <- function(data, expectation = 0) {
  # Real mean is 0 for the t-distribution with 4 DOF.
  s <- 0; B <- length(data)
  for (i in 1:B) {
    s <- s + (data[i] - expectation) ^ 2
  }
  return(s / B)
}
mserrors <- lapply(estimators, mse) # logistic M-est 'wins'
format(as.data.frame(means), digits = 4)
format(as.data.frame(variances), digits = 4)
format(as.data.frame(mserrors), digits = 4)

## C
estimators <- list(tr00 = replicate(n, mean(rcauchy(100))),
                   tr10 = replicate(n, mean(rcauchy(100), .1)),
                   tr20 = replicate(n, mean(rcauchy(100), .2)),
                   tr30 = replicate(n, mean(rcauchy(100), .3)),
                   tr40 = replicate(n, mean(rcauchy(100), .4)),
                   tmed = replicate(n, median(rcauchy(100))),
                   tmlo = replicate(n, mlogis(rcauchy(100))),
                   tmhu = replicate(n, mhuber(rcauchy(100))))
means <- lapply(estimators, mean)
variances <- lapply(estimators, var)
mserrors <- lapply(estimators, mse)
format(as.data.frame(means), digits = 4)
format(as.data.frame(variances), digits = 4)
format(as.data.frame(mserrors), digits = 4)

### Exercise 2
## A
c <- read.table("clouds.txt")
cs = c$seeded.clouds
cu = c$unseeded.clouds
p1 <- hist(cs)
p2 <- hist(cu)
plot(p1, col=rgb(0,0,1,1/4), 
     main="Blue for seeded,\nred for unseeded clouds", 
     xlab="Precipitation values")
plot(p2, col=rgb(1,0,0,1/4), add=T)
mean(cs)
mean(cu)

## B
mea <- function(data) {
  xbar = mean(data)
  s <- 0; B <- length(data)
  for (i in 1:B) {
    s <- s + (data[i] - xbar) ^ 2
  }
  return(sqrt(s / (B-1)))
}
mea(cs)
mea(cu)

## C and D
bs1 = bootstrap(cs, mea, B=1000); sd(bs1)
bs2 = mea(cs); bs2
print("Seeded 95% confidence interval for for current measure of acc.")
c(bs2-quantile(bs1-bs2, probs=.975), bs2-quantile(bs1-bs2, probs=.025))

bs1 = bootstrap(cu, mea, B=1000); sd(bs1)
bs2 = mea(cu); bs2
print("Unseeded 95% confidence interval for current measure of acc.")
c(bs2-quantile(bs1-bs2, probs=.975), bs2-quantile(bs1-bs2, probs=.025))

## E
mea <- function(data) { return(mad(data)) }
# Now re-run from below previous mea definition.

get_name <- function() { 
  if (options$effectSizesCheckbox == "cohensD") {
    return("Cohen's d")
  }	else if (options$effectSizesCheckbox == "glassD") {
    return("Glass' delta")
    # Should give feedback on which data is considered 2.
  } else if (options$effectSizesCheckbox == "hedgesG") {
    return("Hedges' g (corrected)")
  }
}

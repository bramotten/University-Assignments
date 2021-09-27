setwd("C:\\Users\\Bram\\Documents\\Google Drive\\Uni\\Statistical Data Analysis\\Assignment 3")
source("./functions_Ch3.txt")

### Exercise 3.1
## A
body_data = read.table("body.dat.txt")
calf_girth = body_data$V19[1:70]
ankle_girth = body_data$V20[1:70]
par(mfrow=c(1,1))
qqplot(calf_girth, ankle_girth, main="Two sample QQ-plot of\nankle and calf girth measurements")
# REPORT: yes.

## B
qqnorm(calf_girth)
qqnorm(ankle_girth)
# If we call those r.v. X's, they're X = a + b * N(0,1)
b_c = sd(calf_girth); a_c = mean(calf_girth)
b_a = sd(ankle_girth); a_a = mean(ankle_girth)
par(mfrow=c(1,2))
qqnorm(calf_girth, main="Normal QQ-plot of\ncalf girth measurements"); abline(a_c, b_c)
qqnorm(ankle_girth, main="Normal QQ-plot of\nankle girth measurements"); abline(a_a, b_a)
# REPORT: just state these.

## C
cma_girth = calf_girth - ankle_girth
qqnorm(cma_girth)
# REPORT: no! And some reason.

## D
shapiro.test(cma_girth)
# REPORT: we can't conclude cma_girth is NOT normally distributed

## E
calf_girth_a = body_data$V19
ankle_girth_a = body_data$V20
cma_girth_a = calf_girth_a - ankle_girth_a
par(mfrow=c(1,1))
qqnorm(cma_girth_a); abline(mean(cma_girth_a), sd(cma_girth_a))
shapiro.test(cma_girth_a)
# REPORT: can now be more confident

### Exercise 3.2
## A
sample_data = scan("sample2019.txt")
qqchisq(sample_data,df=3)
# REPORT: just state these, parameters bij Jim.

## B
rgs = rgamma(n=length(sample_data), shape=2, scale=2.2)
plot(sort(sample_data))
plot(sort(rgs))
ks.test(sample_data, rgs)
# REPORT: not rejected, alpha >> .05

## C
chisquare  <-  function(x, pdist, k=0, lb=0, ub=0, breaks, ...)
{
  n <- length(x)
  if(missing(breaks))
    b <- lb + ((0.:k) * (ub - lb))/k
  else {
    b <- breaks
    k <- length(breaks) - 1.
  }
  N <- table(cut(x, b))
  q <- pdist(b, shape=2, scale=2.2)
  p <- diff(q)
  chi <- sum(((N - n * p)^2.)/(n * p))
  pr <- 1. - pchisq(chi, k - 1.)
  np <- n * p
  y <- list(chi, pr, N,np)
  names(y) <- c("chisquare", "pr", "N","np")
  y
}
chisquare(sample_data, pgamma, 4, 0, 12)
# REPORT: same cc but different P, say we had to change function.

## D 
# REPORT: yes, but this only confirms that we can't say the data is NOT gamma(2,2.2).

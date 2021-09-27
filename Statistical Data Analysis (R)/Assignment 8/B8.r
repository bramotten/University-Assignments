rm(list = ls())
par(mfrow = c(1,1))
set.seed(123)
setwd(sprintf("%s%s", "C:\\Users\\Bram\\Documents\\Google Drive\\",
              "Uni\\Statistical Data Analysis\\Assignment 8"))

### Exercise 1
x <- scan("statgrades.txt"); n <- length(x)
x <- x[-27]
## A
binom.test(sum(x >= 7.22), n-1, p = 0.5, alternative = "l") # p = 0.082
## B
binom.test(sum(x >= 6.6), n, p = 0.5, alternative = "g")$p.value +
  binom.test(sum(x <= 6.6), n, p = 0.5, alternative = "l")$p.value # p = 0.088
binom.test(sum(x >= 6.6), n, p = 0.5, alternative = "t")$p.value # p = 0.088
## C
binom.test(sum(x >= 6.5), n, p = 0.4, alternative = "g")$p.value # p = 1.3e-4

### Exercise 2

## A
X <- read.table("clouds.txt")$unseeded.clouds; N = length(X)
hist(X)
plot(sort(X)) # => prefer sign test.

## B 
muH = 118.5
binom.test(sum(X <= muH), N, p = 0.5, alternative = "t")$p.value # p = 0.076

## C
t.test(X, mu = muH, alt="t", conf.level = .9) # [71.28, 257.84]
wilcox.test(X, mu = muH, alt="t", conf.int = T, 
            conf.level = .9) # [43.20, 175.20] with some whining about ties
pbinom(8:9, size=N, prob=.5) # crosses the 5% barrier.
1-pbinom(16:17, size=N, prob=.5) # .. the 95% barrier.
uscs <- sort(X); uscs
c(uscs[9], uscs[17+1]) # 26.3 95.0
1-pbinom(16,25,0.5) # = 0.05387607
pbinom(9,25,0.5)    # = 0.1147615
# Alternatively
c(uscs[9], uscs[17]) # 26.3 87.0
1-pbinom(17,N,0.5) # = 0.05387607
pbinom(9,N,0.5)    # = 0.1147615

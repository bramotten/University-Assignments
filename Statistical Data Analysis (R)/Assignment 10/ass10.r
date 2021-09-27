rm(list = ls())
par(mfrow = c(1,1))
set.seed(123)
setwd(sprintf("%s%s", "C:\\Users\\Bram\\Documents\\Google Drive\\",
              "Uni\\Statistical Data Analysis\\Assignment 10"))

### Exercise 1
## A
ec <- read.table("expensescrime.txt", header = TRUE)
pairs(ec)

## B
ec$employrate <- ec$employ / (ec$pop * 1000) * 100000 # per 100,000
plot(ec$crime, ec$employrate) # export to PDF

## C
cor.test(ec$crime, ec$employrate, method = "k") # p = 2.5e-5

## D (TODO)
B = 1000
permutationtval = numeric(B)
for (i in 1 : B) {
  permutationtval[i] <- cor.test(sample(ec$crime, 1000, replace = TRUE), sample(ec$employrate, 1000, replace = TRUE), method = "k")[[1]]
}
t <- cor.test(ec$crime, ec$employrate, method = "k")[[1]]
sum(permutationtval <= t) / B

perm.relation(ec$employrate, ec$crime, method = "k")

### Exercise 2
## A
mytable <- matrix(c(43,38,27,12),nrow=2,ncol=2); mytable
fisher.test(mytable) # p = 0.115

## C
fisher.test(mytable, alternative = "l") # p = 0.068
# p = 0.97 with alternative = "g".

## D
# Page 98 of syllabus can't be recreated without deviating from slides:
mytable
x = 43      # N11
m = 43 + 38 # N1.
n = 27 + 12 # N.2
k = 43 + 27 # N.1
phyper(x, m, n, k, lower.tail=T) # p = 0.068

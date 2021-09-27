rm(list = ls())
par(mfrow = c(1, 1))
set.seed(123)
setwd(
  sprintf(
    "%s%s",
    "C:\\Users\\Bram\\Documents\\Google Drive\\",
    "Uni\\Statistical Data Analysis\\Assignment 11"
  )
)

source("functions_Ch7.txt")
source("functions_Ch8.txt")

### Exercise 1
## A
nausea <- read.table("nausea.txt", header = T)
nausea$No.Nausea <-
  nausea$Number.of.Patients - nausea$Incidence.of.Nausea
pvec <- c()
ovec <- c()
for (i in 1:5) {
  ding <- matrix(
    c(
      nausea$Incidence.of.Nausea[1],
      nausea$No.Nausea[1],
      nausea$Incidence.of.Nausea[i],
      nausea$No.Nausea[i]
    ),
    nrow = 2,
    ncol = 2
  )
  
  pvec[i] <- fisher.test(ding, alternative = "g")[1]
  ovec[i] <- fisher.test(ding, alternative = "g")[3]
}
nausea$p <- pvec
nausea$odds <- ovec
nausea

## C
# Change data a bit so it works for a chisq.test function in R
no_nausea <-
  nausea$Number.of.Patients - nausea$Incidence.of.Nausea
n <- matrix(no_nausea, nrow = 5, ncol = 1)
colnames(n) <- 'no nausea'
nausea2 <- cbind(nausea$Incidence.of.Nausea, n)
chisq.test(nausea2)$expected
chisq.test(nausea2)

## D
residuals <- nausea - chisq.test(nausea2)$expected
contribution <- chisq.test(nausea2)$residuals
normalized_dist <- round(chisq.test(nausea2)$stdres, 2)

## E
pvec2 <- c()
for (i in 1:5) {
  ding <- matrix(
    c(
      nausea$Incidence.of.Nausea[1],
      nausea$No.Nausea[1],
      nausea$Incidence.of.Nausea[i],
      nausea$No.Nausea[i]
    ),
    nrow = 2,
    ncol = 2
  )
  
  pvec2[i] <- chisq.test(ding)$p.value
}
pvec2

### Exercise 2
## B
austen <- read.table("austen.txt", header = TRUE)
austens_own <- austen[1:3]
chisq.test(austens_own)
chisq.test(austens_own)$expected
chisq.test(austens_own)$residuals

## C
chisq.test(austen[3:4])
chisq.test(austen[3:4])$expected
chisq.test(austen[3:4])$residuals

chisq.test(austen[, 1:3], simulate.p.value = TRUE, B = 2000)
chisq.test(austen[, 3:4], simulate.p.value = TRUE, B = 2000)

## E
A1 <- austen[, 1:3]
m1 <- maxcontributionscat(A1)
bootval1 <- bootstrapcat(A1, 1000, maxcontributionscat)
mean(bootval1 >= m1)

A2 <- austen[, 3:4]
m2 <- maxcontributionscat(A2)
bootval2 <- bootstrapcat(A2, 1000, maxcontributionscat)
mean(bootval2 >= m2)

## F
maxcontributionscat4 <- function(x) {
  C <- chisq.test(x)$residuals
  sort(abs(C))[length(C) - 3]
}

m1 <- maxcontributionscat4(austen[, 1:3])
bootval1 <-
  bootstrapcat(austen[, 1:3], 1000, maxcontributionscat4)
mean(bootval1 >= m1)

m2 <- maxcontributionscat4(austen[, 3:4])
bootval2 <-
  bootstrapcat(austen[, 3:4], 1000, maxcontributionscat4)
mean(bootval2 >= m2)

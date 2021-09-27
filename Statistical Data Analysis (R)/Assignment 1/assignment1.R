setwd("C:\\Users\\Bram\\Documents\\Google Drive\\Uni\\Statistical Data Analysis\\Assignment 1")
library(moments)

### Exercise 1.3

t = function(n, df) {
  Xrange = c(-10,10)
  hist(rt(n, df), prob=T, xlim=Xrange, xlab="x", ylim=c(0,0.6), breaks=seq(-1500,1500,1),
       ylab="Probability", main=paste("T dist hist fit (sample\nsize", 
                              n, " and ", df, "DOF)"))
  Xseq = seq(from=Xrange[1], to=Xrange[2], by=.1)
  lines(Xseq, dt(Xseq, df), col="red")
}

par(mfrow=c(2,2))
t(10, 3)
t(10, 30)
t(1000, 3)
t(1000, 30)

### Exercise 1.4

data <- read.table("fishcatch.dat.txt")
dataP = subset(data, V2 <= 2 | V2 >= 6)
x1 = subset(dataP, V2 == 1)$V6
x2 = subset(dataP, V2 == 2)$V6
x6 = subset(dataP, V2 == 6)$V6
x7 = subset(dataP, V2 == 7)$V6
par(mfrow=c(1,1))
boxplot(x1, x2, x6, x7, main="Fish length\n(nose to end of tail)", 
        ylab="cm", xlab="Type of fish\n(initials of Latin names)")
axis(1, at=1:4, labels=c("AB", "LI", "EL", "PF"))

x = x6
print("###")
print(mean(x))
print(median((x)))
print(var(x))
print(skewness(x))
print(kurtosis(x))
print(quantile(x))

par(mfrow=c(2,2))
AB = subset(dataP, V2 == 1)$V6
LI = subset(dataP, V2 == 2)$V6
EL = subset(dataP, V2 == 6)$V6
PF = subset(dataP, V2 == 7)$V6
hist(AB, prob=T, xlim=c(0,70), ylim=c(0,0.1), breaks=seq(0,70,5), ylab="Proportion", xlab="Length (nose to end of tail)")
hist(LI, prob=T, xlim=c(0,70), ylim=c(0,0.1), breaks=seq(0,70,5), ylab="Proportion", xlab="Length (nose to end of tail)")
hist(EL, prob=T, xlim=c(0,70), ylim=c(0,0.1), breaks=seq(0,70,5), ylab="Proportion", xlab="Length (nose to end of tail)")
hist(PF, prob=T, xlim=c(0,70), ylim=c(0,0.1), breaks=seq(0,70,5), ylab="Proportion", xlab="Length (nose to end of tail)")

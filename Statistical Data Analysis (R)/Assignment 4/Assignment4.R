setwd("C:\\Users\\Jim\\Documents\\Rscripts")
source("./functions_Ch3.txt")
source("./functions_Ch4.txt")
gamma2 = scan('gamma.txt')
birthweight2= scan('birthweight.txt')

## Exercise 4.1
## A

# My own creation by def. of syllabus
skewness = function(x)
{
  y = sqrt(length(x))*((sum((x-mean(x))^3))/((sum((x-mean(x))^2))^(3/2)))
  y
}
# found on the webs, kon die package niet vinden
skewness2 <-  function(x) {
  m3 <- mean((x-mean(x))^3)
  skew <- m3/(sd(x)^3)
  skew
}

## B

# kan ook met EmpBS=bootstrap(data, skewness,B=1000)
B = 1000;
EmpBS= numeric(B);
for (i in 1: B)
{
  xstar = sample(gamma2, replace = TRUE)
  EmpBS[i] = skewness(xstar)
}

skewness(EmpBS)

## C
ParBS= numeric(B);
u <- mean(gamma2);
v <- var(gamma2);
for (i in 1: B)
{
  xstar = rexp(length(gamma2), 1/u)
  ParBS[i] = skewness(xstar) 
}

skewness(ParBS)

## D
par(mfrow=c(1,2))
hist(ParBS, main = "Empirical")
hist(EmpBS, main = "Parametric")

# Skewness(EmpBS) wordt steeds net onder 0, 
# SKewness(ParBS) komt dichtbij de 'echte' skewness van 1.265

## E

mean(ParBS)
mean(EmpBS)
var(ParBS)
var(EmpBS) #what kind of estimators? MLE ? Moments? Bootstrap?




## Exercise 4.2
##A
# qq-plot for N(0,1) gives good graphical fit for data.
bw=sort(birthweight2)
qqnorm(bw); qqline(bw) 


# t-dist geeft ook goed ogende fit met 8 vrijheidsgraden. (valt te verwachten)
b=sqrt(var(bw)/(8/6))
a=mean(bw)
qqt(bw,df=8); abline(a,b)

##B
# parametric bootstrappen met N(0,1)
ParBS2=numeric(B);
u = mean(bw);
sigma = var(bw);
for (i in 1: B)
{
  xstar = rnorm(length(birthweight2), u,sqrt(sigma))
  ParBS2[i] = median(xstar) 
}
var(ParBS2)

#Kan nog met  t-dist. of empirical bs proberen.
ParBS3=numeric(B);
for (i in 1: B)
{
  xstar = rt(length(birthweight2), df=8)
  ParBS3[i] = median(xstar) 
}
var(ParBS3)

#Empirical:
var(bootstrap(birthweight2,median,B))




##C












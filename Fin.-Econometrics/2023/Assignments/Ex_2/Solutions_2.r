setwd("G:/My Drive/Corsi/FinEc/Course/2024/Exercises/Ex_2")

###### EXERCISE 1

data <-read.table("Table_txt.txt", header=TRUE, na.strings="null", sep = ",")
head(data) # have a look at the data, column names look strange
colnames(data) <- c("AAPL","RF","MKT") # Change columns' names


###### EXERCISE 2

zAAPL <- diff(log(data$AAPL))*100 # compute logreturn, x100 makes it expressed as a percentage
zMKT <- diff(log(data$MKT))*100 # compute logreturn, x100 makes it expressed as a percentage
n <- length(data$RF) # numbers of rows in z
rf <- data$RF[1:(n-1)]/360 #take all rows except the last, so rows from 1 to n-1. Divide by 360 to make the values expressed on a daily basis.
r_matrix <- cbind(zAAPL-rf,zMKT-rf) # (i) make excess retunrns: subtract the risk-free rate, (ii) bind the two columns vectors 
r <- data.frame(r_matrix) # make a data frame for the excess returns
colnames(r) <- c("zAAPL","zMKT") # Change columns' names
head(r) # have a look at the data


###### EXERCISE 3

fit <- lm("zAAPL~zMKT",r) #fits a linear model (with intercept)
res <- summary(fit) # prints a variety of statistics and stores them in "res"
df <- nrow(r)-sum(!complete.cases(r))-2 # number of rows in r - rows with missing values - number of estimated parameters
# Intercept is insignificant (this makes sense in the CAPM context). The slope is highly singificant.
# The t-stat for the intercept is huge (consider that for a normal approximation of the t-student which would hold asympotically for large n, 
# and here n is quite large so the comparison is reasonable) the 0.99 quantile is 2.23 which is far below 29: no surprise that the p-value is tiny
# indicating the rejection of the hypothesis b_0 = 0.

###### EXERCISE 4

b0 <- res$coefficients[1,1] #extracts the estimated coefficient for the intercept
se_0 <- res$coefficients[1,2] #extracts the standard error for the intercept
t_stat <- b0/se_0 # computes the t-statistics
(1-pt(t_stat,df))*2 # p-value
#2*pt(-t_stat,df) # p-value (analogous)
# the probabaility that R gives is "Pr(t>|t_val|)"
# this is "Pr(t< -t_val) + Pr(t> t_val)" so 
# [CDF of a t-distribution with df degrees of freedom evaluated at -t_val] +  [1-(CDF of a t-distribution with df degrees of freedom evaluated at t_val)]
# this is: pt(-t_val,df) + 1-pt(t_val,df)
# Note that since the t-distribution is symmetric: pt(-t_val,df) = 1-pt(t_val,df)
# then Pr(t>|t_val|) = 2*(1-pt(t_val,df)) = 2*pt(-t_val,df)


###### EXERCISE 5

resid <- res$residuals # extract regression residuals
plot(resid) # the mean is approximately constant and zero, however there's evidence of heteroskedasticity
s0 <- (sum(resid^2)/df)^0.5 # Residuals'standard error (same that summary(fit) returns)


###### EXERCISE 6

t_crit = qt(0.975,df) # the critical value correspond to a quantile, the distribution is a student-t with df degrees of freedom
# the quantile you are looking for is that that of order (1-confidence_level/2) = 0.975
low_95 = b0-t_crit*se_0 # lower bound
upp_95 = b0+t_crit*se_0 # upper bound

# Alternatively, this is equivalent
#t_crit = qt(c(0.025,0.975),df)
#low = b0+t_crit[1]*se_0 # lower bound
#upp = b0+t_crit[2]*se_0 # upper bound


t_crit = qt(0.995,df) # the critical value correspond to a quantile, the distribution is a student-t with df degrees of freedom
# the quantile you are looking for is that that of order (1-confidence_level/2) = 0.975
low_99 = b0-t_crit*se_0 # lower bound
upp_99 = b0+t_crit*se_0 # upper bound

# Compared to the 95% CI, this is wider which makes sense since the 99% region under the H0 distribution needs to be wider than the 95% region

###### EXERCISE 7

x <- na.omit(r$zMKT) # exclude missing values from the dependent variable
SST = sum((x-mean(x))^2) # SST
var_b1 <- s0/sqrt(SST) # se of the slope
var_b1


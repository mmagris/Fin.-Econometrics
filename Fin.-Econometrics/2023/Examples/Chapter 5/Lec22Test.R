#fit a regression model
model <- lm(mpg~disp+hp, data=mtcars)
s <- summary(model)

## GQ TEST
library(lmtest)
gq = gqtest(model, order.by = ~disp+hp, data = mtcars, fraction = 0.3)


## WHITE TEST
r <- model$residuals
model2 <- lm(r^2~disp + hp + disp*hp + I(disp^2) + I(hp^2), data = mtcars)
s <- summary(model2)
s$r.squared*32

bptest(model, ~ disp*hp + I(disp^2) + I(hp^2), data = mtcars)

## DW TEST
library(car)
durbinWatsonTest(model)

model <- lm(mpg ~ disp+wt, data=mtcars)
durbinWatsonTest(model)
s <- summary(model)
r <- s$residuals
plot(r[1:31],r[2:32])

## BG TEST
df <- data.frame(x1=c(3, 4, 4, 5, 8, 9, 11, 13, 14, 16, 17, 20),
                 x2=c(7, 7, 8, 8, 12, 4, 5, 15, 9, 17, 19, 19),
                  y=c(24, 25, 25, 27, 29, 31, 34, 34, 39, 30, 40, 49))


model <- lm(df$y ~df$x1+df$x2)
s <- summary(model)

bgtest(y ~ x1 + x2, order=3, data=df)


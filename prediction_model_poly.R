library(ggplot2)

data <- read.csv('./data/beerhall.csv', header=TRUE)

colnames(data) <- c("County", "Region", "Region_Code", "Criminals_per_100k", 
                    "Ale_Beer_Houses_per_100k", "Attendants_at_School_per_10k", 
                    "Attendants_at_Public_Worship_per_2000")
# Load necessary library for regression modeling


# Fit a multiple linear regression model
model <- lm(Criminals_per_100k ~ Ale_Beer_Houses_per_100k + 
              Attendants_at_School_per_10k + 
              Attendants_at_Public_Worship_per_2000, data = data)
L1O<-1:8
for (k in 1:8) {
  output<-0
  for (l in 1:40){
      traindata <- data[-l,]
      modelA <- lm(Criminals_per_100k ~ polym(Ale_Beer_Houses_per_100k, Attendants_at_School_per_10k, degree =  k), data = traindata)
      output <- output+(predict(modelA, newdata = data)[l]-data$Criminals_per_100k[l])^2
  }
  L1O[k]<-(output/40)**0.5
}

L2O<-1:8
for (k in 1:8) {
  output<-0
  for (l in 1:39){
  for (x in (l+1):40) {
    traindata <- data[-c(x,l),]
    modelA <- lm(Criminals_per_100k ~ polym(Ale_Beer_Houses_per_100k, Attendants_at_School_per_10k, degree =  k), data = traindata)
    output <- output+(predict(modelA, newdata = data)[x]-data$Criminals_per_100k[x])^2
    output <- output+(predict(modelA, newdata = data)[l]-data$Criminals_per_100k[l])^2
  }
  }
  L2O[k]<-(2*output/(40*39))**0.5
}
L1O
L2O

modelF <- lm(Criminals_per_100k ~ polym(Ale_Beer_Houses_per_100k, Attendants_at_School_per_10k, degree =  4), data = data)
modelF2 <- lm(Criminals_per_100k ~ polym(Ale_Beer_Houses_per_100k, Attendants_at_School_per_10k, degree =  3), data = data)
summary(modelF)
summary(modelF2)
summary(model)


# Create a first line
plot(1:6, L1O[1:6], type = "b", frame = FALSE, pch = 19, 
     col = "red", xlab = "Degrees", ylab = "Error", ylim = c(35, 100))
# Add a second line
lines(1:6, L2O[1:6], pch = 18, col = "blue", type = "b", lty = 2)
# Add a legend to the plot
legend("topleft", legend=c("L1O", "L2O"),
       col=c("red", "blue"), lty = 1:2, cex=0.8)


# Create a first line
plot(1:4, L1O[1:4], type = "b", frame = FALSE, pch = 19, 
     col = "red", xlab = "Degrees", ylab = "Error", ylim = c(35,60))
# Add a second line
lines(1:4, L2O[1:4], pch = 18, col = "blue", type = "b", lty = 2)
# Add a legend to the plot
legend("topleft", legend=c("L1O", "L2O"),
       col=c("red", "blue"), lty = 1:2, cex=0.8)

library(ggplot2)

data <- read.csv('./data/beerhall.csv', header=TRUE)

colnames(data) <- c("County", "Region", "Region_Code", "Criminals_per_100k", 
                    "Ale_Beer_Houses_per_100k", "Attendants_at_School_per_10k", 
                    "Attendants_at_Public_Worship_per_2000")
# Load necessary library for regression modeling
library(ggplot2)

# Fit a multiple linear regression model
model <- lm(Criminals_per_100k ~ Ale_Beer_Houses_per_100k + 
              Attendants_at_School_per_10k + 
              Attendants_at_Public_Worship_per_2000, data = data)

# Summarize the model
summary(model)

# Make predictions
predictions <- predict(model, newdata = data)

# Print the predictions
print(predictions)
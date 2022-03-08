## Load packages
library(googledrive)
library(dplyr)
library(tidyverse)
library(readr)
library(lubridate)
library(ggplot2)
library(here)
library(tidyr)
options(warn = -1)

# Data exploration
#-----------------
## Loading merged_data of airbnb listings and covid
merged_data<- read.csv(here("gen/temp", "merged_data.csv"))
summary(merged_data)

## Plotting weekly_count cases against price
ggplot(merged_data, aes(x = weekly_count, y = price)) +
  geom_point(fill = "steelblue") +
  scale_y_log10()

##No clear relation between weekly_count and price

## Plotting distribution of price
ggplot(merged_data, aes(x = price)) +
  geom_histogram(bins = 30, fill = "steelblue") +
  labs(title = "Distribution of Price") +
  xlim(c(0,1200))

### Plotting distribution of price by room type
ggplot(merged_data, aes(x=price)) +
  geom_histogram() +
  facet_wrap(~room_type) +
  labs(title = "Distribution of Price by Room Type")

# Analysis: Regression model
#-----------------
## Model regresses listings' prices on covid weekly cases and other characteristics of listings
model_1 <- lm(log(price) ~ room_type + minimum_nights + number_of_reviews  + reviews_per_month +
                calculated_host_listings_count + availability_365 + number_of_reviews_ltm +
                weekly_count, merged_data)
summary(model_1)

model_2 <- lm(log(price) ~ room_type + minimum_nights + weekly_count, merged_data)
summary(model_2)


## Model regresses listings' prices on characteristics of listings
###removing outliers from combined_data to build regression model
final_data <- combined_data%>%
  filter(price < 1200, minimum_nights < 6000)

model_3 <- lm(price ~ room_type + minimum_nights + number_of_reviews  + reviews_per_month +
                calculated_host_listings_count + availability_365 + number_of_reviews_ltm, final_data)
summary(model_3)


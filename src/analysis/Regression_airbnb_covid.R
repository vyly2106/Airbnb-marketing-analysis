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


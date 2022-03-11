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
## Loading merged_data of airbnb listings and covid
merged_data <- read.csv(here("gen/temp", "merged_data.csv"))
summary(merged_data)

## Model regresses listings' prices on covid weekly cases and other characteristics of listings
model_1 <-
  lm(
    log(avg_price) ~ room_type + minimum_nights + number_of_reviews  + reviews_per_month +
      availability_365 + number_of_reviews_ltm +
      weekly_count,
    merged_data
  )
summary(model_1)

model_2 <-
  lm(log(avg_price) ~ room_type + minimum_nights + weekly_count,
     merged_data)
summary(model_2)

## Install the necessary packages
install.packages("car")

## Load packages
library(googledrive)
library(dplyr)
library(tidyverse)
library(readr)
library(lubridate)
library(ggplot2)
library(here)
library(tidyr)
library(haven)
library (car)
options(warn = -1)

#----------------------------#
# Analysis: Regression model #
#----------------------------#

## Loading ListingsCovid of airbnb listings and covid
ListingsCovid <- read.csv(here("../../gen/temp", "merged_data.csv"))

#Inspect data:
summary(ListingsCovid)

# Histogram of avg_price(both with and without log function)
ggplot(ListingsCovid, aes(avg_price)) + geom_histogram(bin = 50)
ggplot(ListingsCovid, aes(avg_price)) + geom_histogram(bin = 50) + scale_x_log10()

#Scatterplot of Price per weekly count
ggplot(ListingsCovid,
       aes(x = weekly_count, y = avg_price, color = country_code)) +
  geom_point() +
  scale_y_log10()

#scatterplot of Price per weekly count by country code
ggplot(ListingsCovid,
       aes(x = weekly_count, y = avg_price, color = country_code)) +
  geom_point() +
  scale_y_log10() +
  labs(title = "Price per weekly count by country code") +
  facet_wrap(~ country_code)

## Simple regression with DV Log avg_price and IV weekly_count
ListingsCovid_lm0 <-
  lm(log(avg_price) ~ weekly_count, ListingsCovid)

summary(ListingsCovid_lm0)

## Regression with other characteristics of listings
ListingsCovid_lm1 <-
  lm(
    log(avg_price) ~ weekly_count +
      room_type + minimum_nights +
      reviews_per_month +
      number_of_reviews_ltm +
      availability_365,
    ListingsCovid
  )
summary(ListingsCovid_lm1)

# check multicollinearity
vif(ListingsCovid_lm1)

# check heteroskedasticity
residuals_lm1 <- ListingsCovid_lm1$residuals
ggplot(ListingsCovid, aes(x = weekly_count, y = residuals_lm1)) + geom_point()

## Regression with added interactions between weekly count and room type
ListingsCovid_lm2 <- lm(
  log(avg_price) ~ weekly_count * room_type +
    minimum_nights +
    reviews_per_month +
    number_of_reviews_ltm +
    availability_365,
  ListingsCovid
)
summary(ListingsCovid_lm2)

# check multicollinearity
vif(ListingsCovid_lm2)

# check heteroskedasticity
residuals_lm2 <- ListingsCovid_lm2$residuals
ggplot(ListingsCovid, aes(x = weekly_count, y = residuals_lm2)) + geom_point()
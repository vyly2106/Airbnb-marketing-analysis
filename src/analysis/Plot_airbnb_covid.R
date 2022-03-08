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
ggplot(merged_data, aes(x = weekly_count, y = avg_price)) +
  geom_point(fill = "steelblue") +
  scale_y_log10()

##No clear relation between weekly_count and price

## Plotting distribution of price
ggplot(merged_data, aes(x = avg_price)) +
  geom_histogram(bins = 30, fill = "steelblue") +
  labs(title = "Distribution of Price") +
  xlim(c(0,1200)) +
  facet_wrap(~country_code)


### Plotting distribution of price by room type
ggplot(merged_data, aes(x=avg_price)) +
  geom_histogram() +
  facet_wrap(~room_type) +
  labs(title = "Distribution of Price by Room Type")


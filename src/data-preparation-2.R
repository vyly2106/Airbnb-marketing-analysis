#Data Downloading
#----------------
## Installing and loading necessary packages
library(googledrive)
library(dplyr)
library(tidyverse)
library(readr)
library(lubridate)
library(ggplot2)
options(warn = -1)

#To download all of Europe's listing data to R (Doesn't authorize on my laptop)
#data_id <-"1EuQuvvg4EIWmlRC94ixn0cQvzekYiLX6Q6KTrUfNa8U"
#data_id2 <- "1BHtCZokCgAtHWBDZOI-meOIWLIBp6nbhU4MurlzVHlg"
#drive_download(as_id(data_id2), path = "Airbnb_listings.csv", overwrite = TRUE)
#Airbnb_links <- read.csv("Airbnb_listings.csv")

## Importing Google Sheet as CSV in R
sheet_url <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vQc3s13RpgIW-qvY1qzgW1J7gxYhTWdjpZW5VX7j0JA_EFcdTVbDUwOz5ye-v1zYmLbMt8gPU6G-ka3/pub?gid=1563900716&single=true&output=csv"
Airbnb_links <- read.csv(url(sheet_url), encoding = "UTF-8")
airbnb_urls <- as.character(Airbnb_links$URL)
airbnb_country <- as.character(Airbnb_links$Country_code)
airbnb_urls <- airbnb_urls%>% 
  gsub("ä", "%C3%A4", .) %>% 
  gsub("ü", "%C3%BC", .)



## Reading datasets for all countries
tbl <- lapply(airbnb_urls, function(airbnb_urls){
  print(paste0('Now downloading ... ', airbnb_urls))
  d <- read.csv(airbnb_urls)
  city = tolower(as.character(Airbnb_links$City[match(airbnb_urls, Airbnb_links$URL)]))
  d$city <- city
  country_code = as.character(Airbnb_links$Country_code[match(airbnb_urls, Airbnb_links$URL)])
  d$country_code <- country_code
  return(d)
})

## Combining data into a single data frame
combined_data = do.call('rbind', tbl)
head(combined_data)
glimpse(combined_data)

## Writing data into csv file
write.csv(combined_data, 'combined_city_data.csv', row.names=F)


## Reading Covid data
covid <- read.csv("/Users/claudiali/Downloads/data.csv") #need to use relative path
head(covid)

# Data Cleaning
#--------------
## Airbnb data
### Filtering data for which last review date is not available and convert into year-week format
combined_data <- combined_data%>%
                    filter(last_review != "") %>%
                    mutate(year_week = strftime(last_review, format = "%Y-W%V")) %>%
                    select(-last_review)

### Transforming combined data from day to day to weekly basis
combined_data2 <- combined_data%>%
  group_by(year_week, country_code, room_type)%>%
  summarise(price = mean(price, na.rm = T), minimum_nights = mean(minimum_nights, na.rm = T), number_of_reviews = mean(number_of_reviews, na.rm = T), 
            reviews_per_month = mean(reviews_per_month, na.rm = T), calculated_host_listings_count = mean(calculated_host_listings_count, na.rm = T), 
            availability_365 = mean(availability_365, na.rm = T),
            number_of_reviews_ltm = mean(number_of_reviews_ltm, na.rm = T))


## Covid data 
### Converting covid year_week column to make it compatible with combined_data2 year_week column
library(tidyr)
covid2 <- covid%>%
            separate(year_week, sep = "-", into = c("year", "week"))%>%
            mutate(year_week = paste(year, "-W", week, sep = ""))%>%
            select(-c("year", "week")) %>%
            filter(country_code == airbnb_country & indicator == "cases")


## Final step: Joining covid and combined_data2
merged_data <- inner_join(combined_data2, covid2[,c("year_week", "weekly_count", "rate_14_day", "cumulative_count", "country_code")], 
                        by = c("year_week", "country_code"))

# Data exploration
#-----------------
## Plotting weekly_count cases against price
ggplot(merged_data, aes(x = weekly_count, y = price)) +
  geom_point(fill = "steelblue")

##No clear relation between weekly_count and price

## Plotting relation b/w rate_14_day cases against price
ggplot(merged_data, aes(x = rate_14_day, y = price)) +
  geom_point(fill = "steelblue")

##No significant relation between rate_14_day and price

## Plotting distribution of price
ggplot(merged_data, aes(x = price)) +
  geom_histogram(bins = 10, fill = "steelblue") +
  labs(title = "Distribution of Price")




# Regression model
#-----------------
## Model regresses listings' prices on covid weekly cases and other characteristics of listings
model_1 <- lm(price ~ as.factor(room_type) + minimum_nights + number_of_reviews  + reviews_per_month +
              calculated_host_listings_count + availability_365 + number_of_reviews_ltm +
              weekly_count+ rate_14_day + cumulative_count, full_data)
summary(model_1)

## Model regresses listings' prices on characteristics of listings
###removing outliers from combined_data to build regression model
final_data <- combined_data%>%
  filter(price < 1200, minimum_nights < 6000)

model_2 <- lm(price ~ as.factor(room_type) + minimum_nights + number_of_reviews  + reviews_per_month +
              calculated_host_listings_count + availability_365 + number_of_reviews_ltm, final_data)
summary(model_2)

### The R2 value is 0.06357 which means 6.537% variation in the price is explained by all predictors. The p-value of coefficients for all predictors is 
###less than significance level 0.05, which means all predictors have significant relation with price. But R2 value is too low.

### Plotting the relation between room_type and price
ggplot(final_data, aes(x = room_type, y = price)) +
  geom_bar(stat = "identity", fill = "steelblue") + 
  labs(title = "Distribution of Price by Room Type")

### Relation between price and minimum_nights
ggplot(final_data, aes(x = minimum_nights, y = price)) +
  geom_point(col = "steelblue") +
  labs(title = "Relation b/w Minimum Nights and Price")

### Relation between number_of_reviews and price
ggplot(final_data, aes(x = number_of_reviews, y = price)) +
  geom_point(col = "steelblue") +
  labs(title = "Relation b/w Number of Reviews and Price")

### Plotting relation between calculated_host_listings_count and price
ggplot(final_data, aes(x = calculated_host_listings_count, y = price)) +
  geom_point(col = "steelblue") +
  labs(title = "Relation b/w Calculated Host Listings Count and Price")

### Plotting relation between availability_365 and price
ggplot(final_data, aes(x = availability_365, y = price)) +
  geom_point(col = "steelblue") +
  labs(title = "Relation b/w Availability 365 and Price")


### Plotting relation between number of reviews_ltm and price
ggplot(final_data, aes(x = number_of_reviews_ltm, y = price)) +
  geom_point(col = "steelblue") +
  labs(title = "Relation b/w Availability 365 and Price")



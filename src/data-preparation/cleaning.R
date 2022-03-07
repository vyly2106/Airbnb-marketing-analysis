# Data Cleaning
#--------------
## Airbnb data
### Loading combined_city_data.csv
combined_data <- read.csv(here("gen/temp", "combined_city_data.csv"))
combined_data$room_type <- as.factor(combined_data$room_type)

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
### Loading covid data from data directory
covid <- read.csv(here("data", "covid_data.csv"))
head(covid)

### Converting covid year_week column to make it compatible with combined_data2 year_week column
covid2 <- covid%>%
  separate(year_week, sep = "-", into = c("year", "week"))%>%
  mutate(year_week = paste(year, "-W", week, sep = ""))%>%
  select(-c("year", "week")) %>%
  filter(country_code == airbnb_country & indicator == "cases")


## Final step: Joining covid and combined_data2
merged_data <- inner_join(combined_data2, covid2[,c("year_week", "weekly_count", "rate_14_day", "cumulative_count", "country_code")], 
                          by = c("year_week", "country_code"))

## Writing data into csv file
write.csv(merged_data, here("gen/temp", "merged_data.csv"), row.names=F)


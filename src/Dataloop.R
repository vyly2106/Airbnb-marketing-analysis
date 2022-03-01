#Installing and loading necessary packages
install.packages("googledrive")
library(googledrive)
library(dplyr)
library(ggplot2)
library(tidyverse)

#Data Downloading

# To download all of Europe's listing data to R (Doesn't authorize on my laptop)
#data_id <-"1EuQuvvg4EIWmlRC94ixn0cQvzekYiLX6Q6KTrUfNa8U"
#data_id2 <- "1BHtCZokCgAtHWBDZOI-meOIWLIBp6nbhU4MurlzVHlg"
#drive_download(as_id(data_id2), path = "Airbnb_listings.csv", overwrite = TRUE)
#Airbnb_links <- read.csv("Airbnb_listings.csv")




## Load specific data sets

### Import Airbnb's listings in Q1/2021 from Googlesheet
sheet_url_q1 <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vSsPwSt6TOXs7Em7qSw_a2WBcWg97CiqLs6iZYL5xxfWi6gXN1CW4mI-OKhx1aU9P7iBu04Q6UmwP2W/pub?gid=0&single=true&output=csv"
airbnb_links_q1 <- read.csv(url(sheet_url_q1), fileEncoding="UTF-8")
airbnb_urls_q1 <- as.character(airbnb_links_q1$URL)

datasets_q1 <- lapply(airbnb_urls_q1, function(airbnb_urls_q1) {
  print(paste0('Now downloading ... ', airbnb_urls_q1))
  city = tolower(as.character(airbnb_links_q1$City[match(airbnb_urls_q1, airbnb_links_q1$URL)]))
  res = read.csv(airbnb_urls_q1, header=TRUE, sep=",", row.names=NULL, fileEncoding="UTF-8", skipNul = T)
  res$city <- city
  return(res)
})

combined_q1 = do.call('rbind', datasets_q1)

### Import Airbnb's listings in Q4/2021 from Googlesheet
sheet_url_q4 <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vSsPwSt6TOXs7Em7qSw_a2WBcWg97CiqLs6iZYL5xxfWi6gXN1CW4mI-OKhx1aU9P7iBu04Q6UmwP2W/pub?gid=424615328&single=true&output=csv"
airbnb_links_q4 <- read.csv(url(sheet_url_q4), fileEncoding="UCS-2LE")
airbnb_urls_q4 <- as.character(airbnb_links_q4$URL)

datasets_q4 <- lapply(airbnb_urls_q4, function(airbnb_urls_q4) {
  print(paste0('Now downloading ... ', airbnb_urls_q4))
  city = tolower(as.character(airbnb_links_q4$City[match(airbnb_urls_q4, airbnb_links_q4$URL)]))
  res = read.csv(airbnb_urls_q4, header=TRUE, sep=",", row.names=NULL, fileEncoding="UTF-8", skipNul = T)
  res$city <- city
  return(res)
})

combined_q4 = do.call('rbind', datasets_q4)

#Generate raw data files
write.csv(combined_q1, 'combined_city_data_q1.csv', row.names=F)
write.csv(combined_q2, 'combined_city_data_q2.csv', row.names=F)

# Data preparation and cleaning
test <- combined_q1 %>%
            select("id", "price") %>%
            inner_join(combined_q4, by = "id", suffix = c(".q1", ".q4")) %>%
            mutate(change_in_price = price.q4 - price.q1)
  








#Data Downloading
#----------------
## Install the necessary packages
install.packages("googledrive")
install.packages("dplyr")
install.packages("tidyverse")
install.packages("readr")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("here")
install.packages("tidyr")

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


## Importing Google Sheet as CSV in R
drive_id <- "1BHtCZokCgAtHWBDZOI-meOIWLIBp6nbhU4MurlzVHlg"
drive_download(as_id(drive_id), path = "data/Airbnb_listings.csv", overwrite = TRUE)
Airbnb_links <- read.csv("data/Airbnb_listings.csv")

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
write.csv(combined_data, here("gen/temp", "combined_city_data.csv"), row.names=F)



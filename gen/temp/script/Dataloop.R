#installing and loading necessary packages
install.packages("googledrive")
library(googledrive)
library(dplyr)

# To download list of European countries data to R
data_id <-"1EuQuvvg4EIWmlRC94ixn0cQvzekYiLX6Q6KTrUfNa8U"
drive_download(as_id(data_id), path = "AIRBNB_DATA.csv", overwrite = TRUE)
Airbnb_links <- read.csv("AIRBNB_DATA.csv")

# Load specific data sets
Airbnb_urls <- as.character(Airbnb_links$URL)

Datasets <- lapply(Airbnb_urls, function(url) {
  city <- tolower(as.character(Airbnb_links$City[match(url, Airbnb_links$URL)]))
  country <- tolower(as.character(Airbnb_links$Country[match(url,Airbnb_links$URL)]))
  print(paste('Now downloading ... ', url))
  res <- read.csv(url)
  res$city <- city
  res$country <- country
  return(res)
})


combined_data = do.call('rbind', datasets)

write.csv(combined_data, 'combined_city_data.csv', row.names=F)

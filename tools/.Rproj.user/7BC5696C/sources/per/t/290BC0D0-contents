#installing and loading necessary packages
install.packages("googledrive")
library(googledrive)

# Using looping with return values (i.e., to "save" stuff to carry on working)
results = lapply(1:10, function(x) x*2)

# To download all of Europe's listing data to R
data_id <-"1EuQuvvg4EIWmlRC94ixn0cQvzekYiLX6Q6KTrUfNa8U"
drive_download(as_id(data_id), path = "AIRBNB_DATA.csv", overwrite = TRUE)
Airbnb_links <- read.csv("AIRBNB_DATA.csv")

# Load specific data sets
Airbnb_urls <- as.character(Airbnb_links$URL)

Datasets <- lapply(Airbnb_urls, function(Airbnb_urls) {
  print(paste0('Now downloading ... ', Airbnb_urls))
  city = tolower(as.character(Airbnb_links$City[match(Airbnb_urls, Airbnb_links$URL)]))
  res = read.csv(Airbnb_urls)
  res$city <- city
  return(res)
})

combined_data = do.call('rbind', datasets)

write.csv(combined_data, 'combined_city_data.csv', row.names=F)

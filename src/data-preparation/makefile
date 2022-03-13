DATA = ../../data
TEMP = ../../gen/temp

all: $(DATA)/Airbnb_listings.csv $(TEMP)/combined_city_data.csv

../../data/Airbnb_listings.csv: download.R
	R --vanilla < download.R

../../gen/temp/combined_city_data.csv: ../../data/Airbnb_listings.csv  cleaning.R
	R --vanilla < cleaning.R
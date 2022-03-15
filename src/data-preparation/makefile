DATA = ../../data
TEMP = ../../gen

all: $(DATA)/Airbnb_listings.csv $(TEMP)/combined_city_data.csv $(TEMP)/merged_data.csv

../../data/Airbnb_listings.csv: download.R
	mkdir -p ../../data
	R --vanilla < download.R
.../../
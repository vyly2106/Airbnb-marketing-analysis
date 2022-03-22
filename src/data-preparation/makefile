DATA = ../../data
TEMP = ../../gen/temp

all: $(DATA)/Airbnb_listings.csv $(TEMP)/combined_city_data.csv $(TEMP)/merged_data.csv

#Data-Preparation

$(DATA)/Airbnb_listings.csv: download.R
	mkdir -p $(DATA)
	R --vanilla < download.R

$(TEMP)/combined_city_data.csv: download.R
	mkdir -p $(TEMP)
	R --vanilla < download.R

$(TEMP)/merged_data.csv: $(TEMP)/combined_city_data.csv cleaning.R
	mkdir -p $(TEMP)
	R --vanilla < cleaning.R
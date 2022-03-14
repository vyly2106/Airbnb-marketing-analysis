DATA = ../../data
all: $(DATA)/Airbnb_listings.csv

../../data/Airbnb_listings.csv: download.R
	mkdir -p ../../data
	R --vanilla < download.R
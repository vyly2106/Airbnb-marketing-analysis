DATA = ../../data
TEMP = ../../gen/temp
OUTPUT = = ../../gen/output

all: $(OUTPUT)/data_exploration.html $(OUTPUT)/regression_analysis.html

$(OUTPUT)/data_exploration.html: $(TEMP)/combined_city_data.csv data_exploration.Rmd
	R --vanilla < data_exploration.Rmd

$(OUTPUT)/regression_analysis.html: $(TEMP)/merged_data.csv regression_analysis.Rmd
	R --vanilla < regression_analysis.Rmd
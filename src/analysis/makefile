DATA = ../../data
TEMP = ../../gen/temp
OUTPUT = ../../gen/output

#Analysis

all: $(OUTPUT)/data_exploration.html $(OUTPUT)/regression_analysis.html

$(OUTPUT)/data_exploration.html: $(TEMP)/combined_city_data.csv data_exploration.Rmd
	Rscript -e 'rmarkdown::render("data_exploration.Rmd", output_dir = "../../gen/output")'

$(OUTPUT)/regression_analysis.html: $(TEMP)/merged_data.csv regression_analysis.Rmd
	Rscript -e 'rmarkdown::render("regression_analysis.Rmd", output_dir = "../../gen/output")'
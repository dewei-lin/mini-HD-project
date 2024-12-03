.PHONY: clean run-shiny

# Generate the keyword plot using the Python script
plot/keyword_plot.png: scrapping/scrapping.py scrapping/*.pdf
	mkdir -p plot
	python3 scrapping/scrapping.py

# Generate the progression GIF using the R animation script
plot/progression.gif: anime.R
	mkdir -p plot/frames
	Rscript -e ".libPaths('/usr/local/lib/R/library'); source('anime.R')"

# Clean generated plots and frames
clean:
	rm -rf plot/*.png plot/*.gif plot/frames

# Run the Shiny app
run-shiny:
	R -e "shiny::runApp('survival_compare', host='0.0.0.0', port=3838)"


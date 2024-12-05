.PHONY: clean run-shiny

# Generate the keyword plot using the Python script
plot/keyword_plot.png: scrapping/scrapping.py
	mkdir -p plot
	python3 scrapping/scrapping.py

# Generate the progression GIF using the R animation script
plot/progression.gif: anime.R
	mkdir -p plot/frames
	Rscript -e ".libPaths('/usr/local/lib/R/library'); source('anime.R')"

report.html: report.Rmd plot/keyword_plot.png plot/progression.gif
	Rscript -e "rmarkdown::render('report.Rmd')"

# Clean generated plots, frames, and report
clean:
	rm -rf plot/*.png plot/*.gif plot/frames report.html

run-shiny:
	R -e "shiny::runApp('survival_compare/app.R', port=3838)"





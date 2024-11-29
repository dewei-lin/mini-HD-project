# Makefile to generate plots and run the Shiny app

# Define paths
PLOT_DIR = plot
FRAMES_DIR = $(PLOT_DIR)/frames
SCRAPPING_DIR = scrapping
SURVIVAL_DIR = survival_compare
PY_SCRIPT = $(SCRAPPING_DIR)/scrapping.py
R_ANIME_SCRIPT = anime.R

# Define outputs
KEYWORD_PLOT = $(PLOT_DIR)/keyword_plot.png
PROGRESSION_GIF = $(PLOT_DIR)/progression.gif

# Default target
all: $(KEYWORD_PLOT) $(PROGRESSION_GIF)

# Ensure the plot directory exists before generating plots
$(PLOT_DIR):
	mkdir -p $(PLOT_DIR)

# Ensure the frames directory exists before running animations
$(FRAMES_DIR): $(PLOT_DIR)
	mkdir -p $(FRAMES_DIR)

# Generate the keyword plot using the Python script
$(KEYWORD_PLOT): $(PY_SCRIPT) $(SCRAPPING_DIR)/*.pdf | $(PLOT_DIR)
	python3 $(PY_SCRIPT)

# Generate the progression GIF using the R animation script
$(PROGRESSION_GIF): $(R_ANIME_SCRIPT) | $(PLOT_DIR) $(FRAMES_DIR)
	Rscript -e ".libPaths('/usr/local/lib/R/library'); source('$(R_ANIME_SCRIPT)')"

# Clean generated plots and frames
clean:
	rm -rf $(PLOT_DIR)/*.png $(PLOT_DIR)/*.gif $(FRAMES_DIR)

# Run the Shiny app
run-shiny:
	R -e "shiny::runApp('$(SURVIVAL_DIR)', host='0.0.0.0', port=3838)"

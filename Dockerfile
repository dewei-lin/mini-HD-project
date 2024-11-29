# Use the rocker/tidyverse image as the base for R packages
FROM rocker/tidyverse:4.3.1

# Update and install system dependencies required for R, Python, and R packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    make \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libssl-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    libtiff5-dev \
    libpng-dev \
    ffmpeg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python packages for scraping
RUN pip3 install pdfminer.six matplotlib wordcloud

# Create R library directory and grant permissions
RUN mkdir -p /usr/local/lib/R/site-library && chmod -R 777 /usr/local/lib/R/site-library

# Install R packages in the correct order
RUN Rscript -e "install.packages('units', lib='/usr/local/lib/R/library', repos='https://cloud.r-project.org/')"
RUN Rscript -e "install.packages('sf', lib='/usr/local/lib/R/library', repos='https://cloud.r-project.org/')"
RUN Rscript -e "install.packages('transformr', lib='/usr/local/lib/R/library', repos='https://cloud.r-project.org/')"
RUN Rscript -e "install.packages(c('gifski','av'), lib='/usr/local/lib/R/library', repos='https://cloud.r-project.org/')"
RUN Rscript -e "install.packages(c('gganimate', 'hrbrthemes', 'dplyr', 'shiny', 'plotly', 'ggplot2'), lib='/usr/local/lib/R/library', repos='https://cloud.r-project.org/')"

# Set the working directory inside the container
WORKDIR /project

# Copy the entire project folder into the container
COPY . /project

# Expose the port for the Shiny app
EXPOSE 3838

# Default command to allow the Makefile to control the workflow
CMD ["make", "all"]


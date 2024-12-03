# Use the rocker/tidyverse image as the base for R packages
FROM rocker/verse:latest

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    make \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libssl-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    libtiff5-dev \
    libpng-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# Install Python packages for scraping
RUN pip3 install pdfminer.six matplotlib wordcloud

# Install R packages in the correct order
RUN Rscript -e "install.packages(c('units', 'sf', 'transformr'))"
RUN Rscript -e "install.packages(c('gifski','av'))"
RUN Rscript -e "install.packages(c('gganimate', 'hrbrthemes', 'dplyr', 'shiny', 'plotly', 'ggplot2'))"




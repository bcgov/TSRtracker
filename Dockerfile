FROM rocker/verse:4.4.2
RUN apt-get update && apt-get install -y  gdal-bin libcurl4-openssl-dev libgdal-dev libgeos-dev libicu-dev libnode-dev libpng-dev libproj-dev libsqlite3-dev libssl-dev libudunits2-dev libx11-dev libxml2-dev make pandoc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/local/lib/R/etc/ /usr/lib/R/etc/
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" | tee /usr/local/lib/R/etc/Rprofile.site | tee /usr/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("glue",upgrade="never", version = "1.8.0")'
RUN Rscript -e 'remotes::install_version("DBI",upgrade="never", version = "1.2.3")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.10.0")'
RUN Rscript -e 'remotes::install_version("sf",upgrade="never", version = "1.0-19")'
RUN Rscript -e 'remotes::install_version("geojsonsf",upgrade="never", version = "2.0.3")'
RUN Rscript -e 'remotes::install_version("leaflet",upgrade="never", version = "2.2.2")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3.2")'
RUN Rscript -e 'remotes::install_version("testthat",upgrade="never", version = "3.2.2")'
RUN Rscript -e 'remotes::install_version("xml2",upgrade="never", version = "1.3.6")'
RUN Rscript -e 'remotes::install_version("shinydashboard",upgrade="never", version = "0.7.3")'
RUN Rscript -e 'remotes::install_version("shinycssloaders",upgrade="never", version = "1.1.0")'
RUN Rscript -e 'remotes::install_version("RPostgreSQL",upgrade="never", version = "0.7-7")'
RUN Rscript -e 'remotes::install_version("rmapshaper",upgrade="never", version = "0.5.0")'
RUN Rscript -e 'remotes::install_version("leaflet.extras2",upgrade="never", version = "1.3.1")'
RUN Rscript -e 'remotes::install_version("leaflet.extras",upgrade="never", version = "2.0.1")'
RUN Rscript -e 'remotes::install_version("golem",upgrade="never", version = "0.5.1")'
RUN Rscript -e 'remotes::install_version("ggplot2",upgrade="never", version = "3.5.2")'
RUN Rscript -e 'remotes::install_version("forcats",upgrade="never", version = "1.0.0")'
RUN Rscript -e 'remotes::install_version("data.table",upgrade="never", version = "1.16.4")'
RUN Rscript -e 'remotes::install_version("bsplus",upgrade="never", version = "0.1.5")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone
EXPOSE 3838
CMD  ["R", "-e", "options('shiny.port'=3838,shiny.host='0.0.0.0');library(TSRtracker);TSRtracker::run_app()"]

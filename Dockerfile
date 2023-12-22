# Install Shiny
FROM rocker/shiny:latest

# Install Ubuntu packages

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    wget \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    gsl-bin \
    libgsl0-dev \
    libsasl2-dev


RUN sudo R -e "options(repos = list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/2019-06-12/')); \
  install.packages(c('devtools', 'dplyr', 'shinydashboard', 'mongolite', 'DT', 'shinyjs', 'shinyBS', 'shinyWidgets', 'prettydoc', 'knitr', 'rmarkdown', 'shinydashboardPlus', 'stringr', 'webshot'))"

RUN sudo R -e "devtools::install_github('nik01010/dashboardthemes')"
RUN sudo R -e "devtools::install_github('Kohze/fireData')"

## install phantomjs
RUN sudo R -e "webshot::install_phantomjs()"

# copy the app to the image
ADD shiny_devoteam /srv/shiny-server/

## Copy Shiny Configuration into Docker container
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /srv/shiny-server/shiny-server.sh

WORKDIR /srv/shiny-server

# allow permission
RUN sudo chown -R shiny:shiny /srv/shiny-server

# Make the ShinyApp available at port 3838 and 80
EXPOSE 3838
EXPOSE 80

CMD ["/usr/bin/shiny-server.sh"]

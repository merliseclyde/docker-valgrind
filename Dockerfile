FROM docker.io/rocker/r-devel
MAINTAINER "Merlise Clyde" clyde@duke.edu

RUN apt-get update &&  apt-get install -y --no-install-recommends\
            git valgrind libxml2-dev \
     && . /etc/environment \
     && install2.r --repos 'https://cran.rstudio.com' \
        roxygen2 knitr rmarkdown dplyr ggplot2 GGally glmbb pkgdown testthat covr \
     && rm -rf /tmp/downloaded_packages/ /tmp/*.rds


## httr authentication uses this port
EXPOSE 1410
ENV HTTR_LOCALHOST 0.0.0.0

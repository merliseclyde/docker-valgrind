##FROM docker.io/rocker/r-devel  (use the official one)
FROM r-devel-local

MAINTAINER "Merlise Clyde" clyde@duke.edu

RUN apt-get update &&  apt-get install -y --no-install-recommends\
            git valgrind libxml2-dev libssl-dev pandoc qpdf ghostscript\
     && . /etc/environment \
     && RD -e 'install.packages(c("roxygen2", "knitr", "MASS","rmarkdown","dplyr", "ggplot2","GGally","glmbb", "pkgdown", "testthat", "covr"))' \
     && rm -rf /tmp/downloaded_packages/ /tmp/*.rds


## httr authentication uses this port
EXPOSE 1410
ENV HTTR_LOCALHOST 0.0.0.0

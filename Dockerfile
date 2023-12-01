#FROM docker.io/rocker/r-devel
# docker pull rocker/r-devel
# docker pull wch1/r-debug
FROM wch1/r-debug

MAINTAINER "Merlise Clyde" clyde@duke.edu

RUN . /etc/environment \
     && RDvalgrind -q -e 'install.packages(c("roxygen2", "knitr", "MASS","rmarkdown","dplyr", "ggplot2","GGally","glmbb", "pkgdown", "testthat", "covr"))' \
     && rm -rf /tmp/downloaded_packages/ /tmp/*.rds


## httr authentication uses this port
EXPOSE 1410
ENV HTTR_LOCALHOST 0.0.0.0

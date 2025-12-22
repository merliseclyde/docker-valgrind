#FROM docker.io/rocker/r-devel
# docker pull rocker/r-devel
# docker pull wch1/r-debug
FROM merliseclyde/r-debug

LABEL org.opencontainers.image.authors="clyde@duke.edu"

RUN  apt-get update && apt-get install -y \
     cmake  

RUN  . /etc/environment \
     && RDvalgrind -q -e 'install.packages(c("roxygen2", "knitr", "MASS","rmarkdown","dplyr", "ggplot2","GGally","glmbb", "pkgdown", "testthat", "covr", "faraway"))' \
     && rm -rf /tmp/downloaded_packages/ /tmp/*.rds


## httr authentication uses this port
EXPOSE 1410
ENV HTTR_LOCALHOST=0.0.0.0

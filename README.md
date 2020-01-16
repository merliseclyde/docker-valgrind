# Notes for building a docker image for R-devel with valgrind support
# 

## Preliminary step - get R-devel (or update)
## 

> docker pull rocker/r-devel


# build the Docker file 
# here to add the code for valgrind and libraries for testing BAS so that we do not need to do that in the interactive session 
# 
> docker build -t r-devel-valgrind .

run interactively


> docker run -it r-devel-valgrind bash

or 
> cd ~/BAS-github
> docker run --rm -ti -v ${PWD}:/work -w /work r-devel-valgrind bash

(this allows the files in the package directory to be accessible in the directory /work without using the git clone step below)

If not running in the BAS dir (/work) grab the package from github (may replace with branch)

>> git clone https://github.com/merliseclyde/BAS

>> RD CMD build BAS

>> RD CMD check --as-cran --use-valgrind BAS_1.5.4.tar.gz
>> RD CMD INSTALL --dsym  BAS_1.5.4.tar.gz
>> RD -d "valgrind --tool=memcheck --leak-check=full --track-origins=yes  --log-fd=1 --log-file=BAS.Rcheck/BAS-valgrind.txt" --vanilla < BAS.Rcheck/BAS-Ex.R

Notes:  may need to set env variables or Makefile for valgrind arguments (see Writing R Extensions)

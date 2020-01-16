# Notes for building a docker image for R-devel with valgrind support
# 

## Preliminary step - get R-devel (or update)
## 

> docker pull rocker/r-devel


# build the Docker file 
We will add to the r-devel image valgrind, gcc-9, gfortran-9 and libraries for testing BAS so that we do not need to do that in the interactive session.  This saves time if we need to close the session and restart later as they are already in the container.

We'll gat teh container as r-devel-valgrind

> docker build -t r-devel-valgrind .

# Start up the container to run interactively


> docker run -it r-devel-valgrind bash

or attach the local package director (See http://dirk.eddelbuettel.com/blog/2019/08/05/#023_rocker_debug_example) so that source package is available.

> cd ~/BAS-github
> docker run --rm -ti -v ${PWD}:/work -w /work r-devel-valgrind bash

(this allows the files in the package directory to be accessible in the directory /work without using the git clone step below)

If not running in the BAS dir (/work) grab the package from github (may replace with branch)

>> git clone https://github.com/merliseclyde/BAS


Now build BAS and check it as-cran.  Note we need to replace R with RD an alias for R-devel.

>> RD CMD build BAS

>> RD CMD check --as-cran --use-valgrind BAS_1.5.4.tar.gz
>> RD CMD INSTALL --dsym  BAS_1.5.4.tar.gz
>> RD -d "valgrind --tool=memcheck --leak-check=full --track-origins=yes  --log-fd=1 --log-file=BAS.Rcheck/BAS-valgrind.txt" --vanilla < BAS.Rcheck/BAS-Ex.R

Notes:  may need to set env variables or Makefile for valgrind arguments (see Writing R Extensions)

To Do add emacs if we want to edit files in the container.
See http://dirk.eddelbuettel.com/blog/2019/08/05/#023_rocker_debug_example 

# Notes for building a docker image for R-devel with valgrind support
# 

## Preliminary step - Install Docker



## Build the Docker Container 

We will add to the r-devel image valgrind, gcc-9, gfortran-9 and libraries for testing BAS so that we do not need to do that in the interactive session.  This saves time if we need to close the session and restart later as they are already in the container.

We'll tag the container as r-devel-valgrind

```
docker build -t r-devel-valgrind .
```

## Start up the container to run interactively


```
docker run -it r-devel-valgrind bash
```
or attach the local package directory (See http://dirk.eddelbuettel.com/blog/2019/08/05/#023_rocker_debug_example) so that the source package is available.

```
cd ~/BAS-github
docker run --rm -ti -v ${PWD}:/work -w /work r-devel-valgrind bash
```
(this allows the files in the package directory to be accessible in the directory /work without using the git clone step below and useful if you are fixing bugs and do not want to push local changes to github.  You can edit local files within the container without having to exit and start back up.

If not running in the BAS dir (/work) grab the package from github (may need to replace with branch)

```
git clone https://github.com/merliseclyde/BAS
```

## Check the version of `R` to make sure that the image does have the current R-devel

```
RD --version
```



Now build BAS and check it as-cran.  Note we need to replace R with RD an alias for R-devel.

```
cd ..
RD CMD build BAS

RD CMD check --as-cran --use-valgrind BAS_1.5.4.tar.gz
RD CMD INSTALL --dsym  BAS_1.5.4.tar.gz
RD -d "valgrind --tool=memcheck --leak-check=full --track-origins=yes  --log-fd=1 --log-file=BAS.Rcheck/BAS-valgrind.txt" --vanilla < BAS.Rcheck/BAS-Ex.R
```

Have fun debugging!

Notes:  may need to set ENV variables or edit the package Makefile for valgrind arguments (see Writing R Extensions)

To Do: add emacs and elpa-ess if we want to edit files in the container.


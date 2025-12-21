# Notes for building a docker image for R-devel with valgrind support
# 

## Preliminary step - Install Docker

(make sure that the docker daemon is running)

## Build the Docker Container 

We will add to the r-devel image valgrind, gcc-9, gfortran-9 and libraries for testing BAS so that we do not need to do that in the interactive session.  This saves time if we need to close the session and restart later as they are already in the container.

We'll tag the container as r-devel-valgrind;
we need 'buildx build --platform=linux/amd64' to build on a Mac M1/M3

```
docker buildx build --platform=linux/amd64 -t r-debug-valgrind .
```
or on crunch (no platform specification needed)
```
docker buildx build  -t merliseclyde/r-debug-valgrind .
```

## Start up the container to run interactively


```
docker run -it --platform linux/amd64 r-debug-valgrind bash
```

On crunch: 
```
docker run -it  r-debug-valgrind bash
```

or attach the local directory where the package lives (See http://dirk.eddelbuettel.com/blog/2019/08/05/#023_rocker_debug_example) so that the source package is available.

```
cd ../BAS
docker run --rm  -ti -v ${PWD}:/work -w /work r-debug-valgrind bash
```
to allow the files in the package directory to be accessible in the directory /work without using the git clone step below.  This is useful if you are fixing bugs locally and are not ready to push local changes to github.  You can edit local files within the container without having to exit and start back up, but may want to add your favorite editor [emacs]( to the Docker container ahead of time.



## Check Versions 
 
Before building and checking the package, it is helpful to check the version of `R` and the compliler to make sure that the image does have the current versions that CRAN is expecting (see https://cran.r-project.org/web/checks/check_flavors.html).  At the time of this writing,  gcc-9 and gfortran-9 on Debian

```
gcc --version
gfortan --version
RD --version
```

## Building and checking the package
## 
If not attaching the local directory with the source package (/work), grab the package from github. in this case I am using a branch

```
git clone  https://github.com/merliseclyde/BAS
git clone --single-branch --branch devel https://github.com/merliseclyde/BAS
```

Now build BAS and check it as-cran.  Note we need to replace R with RD an alias for R-devel.

```
RDvalgrind  CMD build BAS
# following needed on ubuntu 
# ulimit 4096
RDvalgrind CMD check --use-valgrind BAS_2.0.1.tar.gz
RDvalgrind  CMD INSTALL --dsym  BAS_2.0.1.tar.gz
RDvalgrind -d "valgrind --tool=memcheck --leak-check=full --track-origins=yes  --log-fd=1 --log-file=BAS.Rcheck/BAS-valgrind.txt" --vanilla < BAS.Rcheck/BAS-Ex.R
cd BAS.Rcheck/tests; 
RDvalgrind -d "valgrind --tool=memcheck --leak-check=full --track-origins=yes --with-valgrind-instrumentation=2 --log-fd=1 --log-file=BAS-valgrind-tests.txt" --vanilla < testthat.R
```

Have fun debugging!

Notes:  may need to set ENV variables or edit the package Makefile for valgrind arguments (see Writing R Extensions)

To Do: add emacs and elpa-ess if we want to edit files in the container.


# Notes for building a docker image for R-devel with valgrind support
# 

## Preliminary step - get R-devel
## 

cd ../docker-r-devel
curl https://raw.githubusercontent.com/rocker-org/rocker/master/r-devel/Dockerfile -O

docker build -t r-devel-local .

or use docker pull rocker/r-devel
#

# build the Docker file here to add the code for valgrind and libraries for testing BAS
# 
> docker build -t r-devel-valgrind .

run interactively


> docker run -it r-devel-valgrind bash

In the docker image 
>> git clone https://github.com/merliseclyde/BAS

>> RD CMD build BAS

>> RD CMD check --as-cran --use-valgrind BAS_1.5.4.tar.gz
>> RD CMD INSTALL BAS_1.5.4.tar.gz
>> RD -d "valgrind --tool=memcheck --leak-check=full --track-origins=yes  --log-fd=1 --log-file=BAS.Rcheck/BAS-valgrind.txt" --vanilla < BAS.Rcheck/BAS-Ex.R

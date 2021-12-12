FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get install -y gfortran

COPY ./src /usr/src/myapp
WORKDIR /usr/src/myapp

RUN gfortran -o part1 part1.f90
RUN gfortran -o part2 part2.f90

CMD ["./run.sh"]

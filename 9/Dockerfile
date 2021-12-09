FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get install -y lua5.3

COPY ./src /usr/src/myapp
WORKDIR /usr/src/myapp

CMD ["./run.sh"]

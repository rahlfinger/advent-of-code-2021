FROM ubuntu:latest
# FROM debian:10-slim
RUN apt-get update
RUN apt-get install -y gnat gprbuild

WORKDIR /tmp/

COPY ./src/* .

RUN gprbuild part1.adb
RUN gprbuild part2.adb
RUN chmod +x run.sh

CMD ["run.sh"]

FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get install -y open-cobol

WORKDIR /tmp/

COPY ./src/* .
RUN chmod +x run.sh

RUN cobc -free -x -o part1 part1.cbl
RUN cobc -free -x -o part2 part2.cbl

CMD ["./run.sh"]

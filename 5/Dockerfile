FROM gcc:latest

COPY ./src /usr/src/myapp
WORKDIR /usr/src/myapp

RUN gcc -o part1 part1.c
RUN gcc -o part2 part2.c

CMD ["./run.sh"]

FROM nimlang/nim

COPY ./src /usr/src/app
WORKDIR /usr/src/app

RUN nim c part1.nim
RUN nim c part2.nim

CMD ["./run.sh"]

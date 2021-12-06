FROM perl:latest

RUN cpan App::cpanminus
RUN cpanm Path::Tiny

COPY ./src /usr/src/myapp
WORKDIR /usr/src/myapp

RUN chmod +x run.sh

CMD ["./run.sh"]

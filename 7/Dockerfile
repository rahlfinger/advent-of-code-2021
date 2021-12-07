FROM julia:latest

COPY ./src /usr/src/myapp
WORKDIR /usr/src/myapp

RUN julia setup.jl

CMD ["./run.sh"]

FROM r-base:latest

COPY ./src /usr/local/src/myscripts
WORKDIR /usr/local/src/myscripts

RUN Rscript -e "install.packages('stringr')"

CMD ["./run.sh"]

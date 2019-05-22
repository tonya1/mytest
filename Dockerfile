#comment
FROM debian:jessie

COPY . /this

RUN apt-get update && apt-get install -y git 
RUN cd /this; git rev-parse --abbrev-ref HEAD

ADD this.py /

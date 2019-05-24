#comment
FROM debian:jessie

ARG BUILD_VERSION

ENV BUILD_VERSION ${BUILD_VERSION}

COPY . /this

RUN env

RUN apt-get update -q && apt-get install -y git 
RUN cd /this; git rev-parse --abbrev-ref HEAD

ADD this.py /

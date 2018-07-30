FROM openjdk:8-jdk-alpine AS build

RUN apk update \
    && apk upgrade \
    && apk add --no-cache curl \
    && curl -L -o javassist-3.11.GA.zip http://downloads.sourceforge.net/project/jboss/Javassist/3.11.0.GA/javassist-3.11.GA.zip

#!/bin/bash

echo "---------------"
echo "in build script"
echo "MYVAR $MYVAR"
echo "MYSECRETVAR $MYSECRETVAR"
echo "DOCKER_PROJECT $DOCKER_PROJECT"

if [ -n "$DOCKER_PROJECT" -a "$MYSECRETVAR" ]; then
  echo "here i am in single brackets"
fi

#if [[ -n "$DOCKER_PROJECT" -a "$MYSECRETVAR" ]]; then
#  echo "here i am in double brackets"
#fi

# parse options
while getopts bp option ; do
  case $option in
    b) # Pass gridappsd tag to docker-compose
      # Docker file on travis relative from root.
      docker build -t test .
      ;;
    p) # Pass gridappsd tag to docker-compose
      #if [ -n "$TAG" -a -n "$ORG" ]; then
      #  echo "docker push ${IMAGE}:${TIMESTAMP}_${GITHASH}"
      #  echo "docker push ${IMAGE}:$TAG"
      #fi
      ./this.py
      ;;
    *) # Print Usage
      usage
      ;;
  esac
done
shift `expr $OPTIND - 1`


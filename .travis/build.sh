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


./this.py

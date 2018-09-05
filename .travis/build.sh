#!/bin/bash

TAG="$TRAVIS_BRANCH"

ORG=`echo $DOCKER_PROJECT | tr '[:upper:]' '[:lower:]'`
ORG="${ORG:-tonyamartin}"
ORG="${ORG:+${ORG}/}"
IMAGE="${ORG}mytest"
TIMESTAMP=`date +'%y%m%d%H'`
GITHASH=`git log -1 --pretty=format:"%h"`

# Pass gridappsd tag to docker-compose
# Docker file on travis relative from root.
docker build -t ${IMAGE}:${TIMESTAMP}_${GITHASH} .
status=$?
if [ $status -ne 0 ]; then
  echo "Error: status $status"
  exit 1
fi

# To have `DOCKER_USERNAME` and `DOCKER_PASSWORD`
# filled you need to either use `travis`' cli 
# and then `travis set ..` or go to the travis
# page of your repository and then change the 
# environment in the settings pannel.  



if [ -n "$DOCKER_USERNAME" -a -n "$DOCKER_PASSWORD" ]; then

  echo " "
  echo "Connecting to docker"
  
  echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
  status=$?
  if [ $status -ne 0 ]; then
    echo "Error: status $status"
    exit 1
  fi
  
  docker images
  if [ -n "$TAG" -a -n "$ORG" ]; then
    # Get the built container name, for builds that cross the hour boundary
    CONTAINER=`docker images --format "{{.Repository}}:{{.Tag}}" ${IMAGE}`
    echo "$CONTAINER"

    echo "docker push ${CONTAINER}"
    docker push "${CONTAINER}"
    status=$?
    if [ $status -ne 0 ]; then
      echo "Error: status $status"
      exit 1
    fi

    echo "docker tag ${CONTAINER} ${IMAGE}:$TAG"
    docker tag ${CONTAINER} ${IMAGE}:$TAG
    status=$?
    if [ $status -ne 0 ]; then
      echo "Error: status $status"
      exit 1
    fi

    echo "docker push ${IMAGE}:$TAG"
    docker push ${IMAGE}:$TAG
    status=$?
    if [ $status -ne 0 ]; then
      echo "Error: status $status"
      exit 1
    fi
  fi

fi


#!/bin/bash

TAG="$TRAVIS_BRANCH"

ORG=`echo $DOCKER_PROJECT | tr '[:upper:]' '[:lower:]'`
ORG="${ORG:-tonyamartin}"
ORG="${ORG:+${ORG}/}"
IMAGE="${ORG}mytest"
TIMESTAMP=`date +'%y%m%d%H'`
GITHASH=`git log -1 --pretty=format:"%h"`

# parse options
while getopts bp option ; do
  case $option in
    b) # Pass gridappsd tag to docker-compose
      # Docker file on travis relative from root.
      docker build -t ${IMAGE}:${TIMESTAMP}_${GITHASH} .
      status=$?
      echo "build status $status"

      ;;
    p) # Pass gridappsd tag to docker-compose
      docker images
      if [ -n "$TAG" -a -n "$ORG" ]; then
        # Get the built container name, for builds that cross the hour boundary
        CONTAINER=`docker images --format "{{.Repository}}:{{.Tag}}" ${IMAGE}`
        echo "$CONTAINER"

        echo "docker push ${CONTAINER}"
        docker push ${CONTAINER}
        status=$?
        echo "push status $status"

        echo "docker tag ${CONTAINER} ${IMAGE}:$TAG"
        docker tag ${CONTAINER} ${IMAGE}:$TAG
        status=$?
        echo "tag status $status"

        echo "docker push ${IMAGE}:$TAG"
        docker push ${IMAGE}:$TAG
        status=$?
        echo "push status $status"
      fi
      ;;
    *) # Print Usage
      usage
      ;;
  esac
done
shift `expr $OPTIND - 1`


#!/bin/bash

TAG="$TRAVIS_BRANCH"

ORG=`echo $DOCKER_PROJECT | tr '[:upper:]' '[:lower:]'`
ORG="${ORG:-tonyamartin}"
ORG="${ORG:+${ORG}/}"
IMAGE="${ORG}mytest"
TIMESTAMP=`date +'%y%m%d%H'`
GITHASH=`git log -1 --pretty=format:"%h"`

git status

echo " "
echo " " 
echo "### " 
echo "### " 
echo "### " 
GITBRANCH=`git rev-parse --abbrev-ref HEAD`
echo "GITBRANCH: $GITBRANCH"
echo "### " 
echo "### " 
echo "### " 
echo " " 

# parse options
while getopts bp option ; do
  case $option in
    b) # Pass gridappsd tag to docker-compose
      # Docker file on travis relative from root.
      docker build -t ${IMAGE}:${TIMESTAMP}_${GITHASH} .
      status=$?
      if [ $status -ne 0 ]; then
        echo "Error: status $status"
        exit 1
      fi

      ;;
    p) # Pass gridappsd tag to docker-compose
      docker images
      if [ -n "$TAG" -a -n "$ORG" ]; then
        # Get the built container name, for builds that cross the hour boundary
        CONTAINER=`docker images --format "{{.Repository}}:{{.Tag}}" ${IMAGE}`
        echo "$CONTAINER"

        echo "docker push ${CONTAINER}"
        docker push "x${CONTAINER}"
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
      ;;
    *) # Print Usage
      usage
      ;;
  esac
done
shift `expr $OPTIND - 1`


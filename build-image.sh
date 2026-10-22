#!/bin/bash

IMAGE=lcos-dev
CONTAINER=lcos-dev

if [ ! -z $(docker ps -q -f name=$CONTAINER) ]; then
    echo "Stopping Container..."
    docker stop ${CONTAINER}
fi

if [ ! -z $(docker container ls -aq -f name=$CONTAINER) ]; then
    echo "Cleanup container"
    docker rm ${CONTAINER}
fi

if [ ! -z $(docker image ls -aq $CONTAINER) ]; then
    echo "Cleanup image"
    docker image rm ${IMAGE}:latest
fi

docker build \
    --build-arg USER=$(whoami) \
    -t ${IMAGE} .
#!/bin/bash

IMAGE=lcos-dev:latest
CONTAINER=lcos-dev

if [ ! -z $(docker ps -q -f name=$CONTAINER) ]; then
    echo "Stopping Container..."
    docker stop ${CONTAINER}
fi

if [ ! -z $(docker container ls -aq -f name=$CONTAINER) ]; then
    echo "Cleanup"
    docker rm ${CONTAINER}
fi

echo "Run"
docker run \
    --network bridge \
    --hostname ${CONTAINER} \
    --publish 5900:5900 \
    --cap-add SYS_ADMIN \
    --name ${CONTAINER} \
    -itd ${IMAGE}
#!/bin/bash

set -e

GOLANG_VERSION="$1"
VERSION="$2"

#docker login -u "$DOCKER_USER" -p "$DOCKER_PASSWORD"

VERSION="${VERSION//v}"
SEMVER=( ${VERSION//./ } )   
VERSION_LENGTH=${#SEMVER[@]}

if [ $VERSION_LENGTH -ne 3 ]; then
    echo "$VERSION is not semver."
    exit 1
fi

docker build -t quay.io/utilitywarehouse/gotenberg:base -f build/base/Dockerfile .
docker build \
    --build-arg GOLANG_VERSION=${GOLANG_VERSION} \
    --build-arg VERSION=${VERSION} \
    -t quay.io/utilitywarehouse/gotenberg:latest \
    -t quay.io/utilitywarehouse/gotenberg:${SEMVER[0]} \
    -t quay.io/utilitywarehouse/gotenberg:${SEMVER[0]}.${SEMVER[1]} \
    -t quay.io/utilitywarehouse/gotenberg:${SEMVER[0]}.${SEMVER[1]}.${SEMVER[2]} \
    -f build/package/Dockerfile .

docker push "quay.io/utilitywarehouse/gotenberg:latest"
docker push "quay.io/utilitywarehouse/gotenberg:${SEMVER[0]}"
docker push "quay.io/utilitywarehouse/gotenberg:${SEMVER[0]}.${SEMVER[1]}"
docker push "quay.io/utilitywarehouse/gotenberg:${SEMVER[0]}.${SEMVER[1]}.${SEMVER[2]}"
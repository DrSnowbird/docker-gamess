#!/bin/bash

# ref: https://github.com/saromleang/docker-gamess.git

if [ $# -lt 1 ]; then
    echo "Usage: $(basename $0) <WEEKLY_PASSOWRD>"
    exit 1
fi

#### ---- VARS ----
## --build-arg BLAS=[none|atlas]
ATLAS_BUILD=${ATLAS_BUILD:-none}

## --build-arg IMAGE_VERSION=[12.04|14.04|15.10|16.04]
IMAGE_VERSION=16.04

## --build-arg REDUCE_IMAGE_SIZE=[true|false]
REDUCE_IMAGE_SIZE=${REDUCE_IMAGE_SIZE:-true}

## -- Weekly password --
WEEKLY_PASSWORD=${1}

if [ "${ATLAS_BUILD}" == "atlas" ]; then
    #with ATLAS math library (Warning! Long build time):
    echo "... ATLAS_BUILD=${ATLAS_BUILD}"
    docker build --no-cache=true -t docker-gamess:public --build-arg IMAGE_VERSION=${IMAGE_VERSION} --build-arg BLAS={ATLAS_BUILD} --build-arg REDUCE_IMAGE_SIZE=${REDUCE_IMAGE_SIZE} --build-arg WEEKLY_PASSWORD=${WEEKLY_PASSWORD} .
else
    #without ATLAS math library:
    echo "... ATLAS_BUILD=${ATLAS_BUILD}"
    # docker build --no-cache=true -t docker-gamess:public --build-arg IMAGE_VERSION=16.04 --build-arg BLAS=none --build-arg REDUCE_IMAGE_SIZE=true --build-arg WEEKLY_PASSWORD=xxxxxx .

    docker build --no-cache=true -t docker-gamess:public --build-arg IMAGE_VERSION=${IMAGE_VERSION} --build-arg BLAS=none --build-arg REDUCE_IMAGE_SIZE=${REDUCE_IMAGE_SIZE} --build-arg WEEKLY_PASSWORD=${WEEKLY_PASSWORD} .
fi

docker images |grep "docker-gamess"



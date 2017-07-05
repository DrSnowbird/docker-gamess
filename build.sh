#!/bin/bash -x

# ref: https://github.com/saromleang/docker-gamess.git

if [ $# -lt 1 ]; then
    echo "Usage: $(basename $0) <WEEKLY_PASSOWRD>"
    exit 1
fi
############################################################
################### Change VARS if needed ##################
############################################################

## --build-arg IMAGE_VERSION=[12.04|14.04|15.10|16.04]
export IMAGE_VERSION=16.04

## --build-arg BLAS=[none|atlas]
ATLAS_BUILD=${ATLAS_BUILD:-none}

## --build-arg REDUCE_IMAGE_SIZE=[true|false]
REDUCE_IMAGE_SIZE=${REDUCE_IMAGE_SIZE:-true}

############################################################
################### DON'T Change below #####################
############################################################
cp ./Dockerfile ./Dockerfile.new
sed -i 's/$IMAGE_VERSION/'${IMAGE_VERSION}'/' Dockerfile.new
#sed -i 's/\\$\\{IMAGE_VERSION\\}/'${IMAGE_VERSION}'/' Dockerfile.new

## -- Weekly password --
WEEKLY_PASSWORD=${1}

if [ "${ATLAS_BUILD}" == "atlas" ]; then
    #with ATLAS math library (Warning! Long build time):
    echo "... ATLAS_BUILD=${ATLAS_BUILD}"
    docker build --no-cache=true -t docker-gamess:public --build-arg IMAGE_VERSION=${IMAGE_VERSION} --build-arg BLAS={ATLAS_BUILD} --build-arg REDUCE_IMAGE_SIZE=${REDUCE_IMAGE_SIZE} --build-arg WEEKLY_PASSWORD=${WEEKLY_PASSWORD} -f Dockerfile.new .
else
    #without ATLAS math library:
    echo "... ATLAS_BUILD=${ATLAS_BUILD}"
    # docker build --no-cache=true -t docker-gamess:public --build-arg IMAGE_VERSION=16.04 --build-arg BLAS=none --build-arg REDUCE_IMAGE_SIZE=true --build-arg WEEKLY_PASSWORD=xxxxxx .

    docker build --no-cache=true -t docker-gamess:public --build-arg IMAGE_VERSION=${IMAGE_VERSION} --build-arg BLAS=none --build-arg REDUCE_IMAGE_SIZE=${REDUCE_IMAGE_SIZE} --build-arg WEEKLY_PASSWORD=${WEEKLY_PASSWORD} -f Dockerfile.new .
fi

docker images |grep "docker-gamess"
rm ./Dockerfile.new


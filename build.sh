#!/bin/bash

# ref: https://github.com/saromleang/docker-gamess.git

if [ $# -lt 1 ]; then
    echo "Usage: $(basename $0) <WEEKLY_PASSOWRD>"
    echo "You need to get GAMESS source download password from:"
    echo "    http://www.msg.ameslab.gov/gamess/License_Agreement.html"
    exit 1
fi

############################################################
################### Change VARS if needed ##################
############################################################

## --build-arg IMAGE_VERSION=[12.04|14.04|15.10|16.04]
export IMAGE_VERSION=16.04

## --build-arg BLAS=[none|atlas]
##   (with ATLAS math library (Warning! Long build time)
ATLAS_BUILD=${ATLAS_BUILD:-none}

## --build-arg REDUCE_IMAGE_SIZE=[true|false]
REDUCE_IMAGE_SIZE=${REDUCE_IMAGE_SIZE:-true}

## --build-arg INSTALL_DIR=/usr/local/bin
INSTALL_DIR=/usr/local/bin

## --build-arg GAMESS_HOME=/usr/local/bin/gamess
GAMESS_HOME=${INSTALL_DIR}/gamess

## -- Docker Image Tag --
IMAGE_TAG="docker-gamess:public"

############################################################
################### DON'T Change below #####################
############################################################

## -- Weekly password --
WEEKLY_PASSWORD=${1}

start_build_time="`date`"

echo "... ATLAS_BUILD=${ATLAS_BUILD}"
docker build --no-cache=true -t ${IMAGE_TAG} \
	--build-arg INSTALL_DIR=${INSTALL_DIR} \
	--build-arg IMAGE_VERSION=${IMAGE_VERSION} \
	--build-arg BLAS={ATLAS_BUILD} \
	--build-arg REDUCE_IMAGE_SIZE=${REDUCE_IMAGE_SIZE} \
	--build-arg WEEKLY_PASSWORD=${WEEKLY_PASSWORD} .
	
end_build_time="`date`"
echo "start_build_time=${start_build_time}"
echo "end_build_time=${end_build_time}"

docker images |grep "${IMAGE_TAG}"


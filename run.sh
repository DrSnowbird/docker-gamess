#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: "
    echo "  ${0} <input_data.inp> [additional arguments, e.g., -p 8]"
    echo "e.g."
    echo "  ${0} X-0165-thymine-X.inp -p 8"
    exit 1
fi

## -- mostly, don't change this --

DOCKER_RUN_ARGS= $

##################################################
#### ---- Mandatory: Change those ----
##################################################
imageTag="docker-gamess:public"

PACKAGE=`echo ${imageTag##*/}|tr "/\-: " "_"`

docker_volume_data1=/home/gamess

local_docker_data1=`pwd`

##################################################
#### ---- Mostly, you don't need change below ----
##################################################

#instanceName=my-${2:-${imageTag%/*}}_$RANDOM
#instanceName=my-${2:-${imageTag##*/}}
instanceName=`echo ${imageTag}|tr "/\-: " "_"`

#### ----- RUN -------
echo "To run: for example"
echo "docker run -d --name ${instanceName} -v ${docker_data}:/${docker_volume_data} ${imageTag}"
echo "---------------------------------------------"
echo "---- Starting a Container for ${imageTag}"
echo "---------------------------------------------"

## docker run --rm -v $HOME/Tools/GAMESS/docker-gamess:/home/gamess docker-gamess:public X-0165-thymine-X.inp -p 1
docker run --rm \
    --name=${instanceName} \
    -v ${local_docker_data1}:${docker_volume_data1} \
    ${imageTag} $*
    

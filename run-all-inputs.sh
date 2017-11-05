#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: *** Notice the only argument is core numbers ***"
    echo "  ${0} <number of cores, e.g., 8>"
    echo "e.g."
    echo "  ${0} 16"
    exit 1
fi

## -- mostly, don't change this --

DOCKER_RUN_ARGS="$1"

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

if [ -e "./scratch" ]; then
    mkdir -p ./scratch
fi

for input in `ls *.inp`
do
    # Remove the .dat file from the previous run
    if [ -e "$(basename $input .inp).dat" ]; then
        rm restart/$(basename $input .inp).dat
    fi

    ## docker run --rm -v $HOME/Tools/GAMESS/docker-gamess:/home/gamess docker-gamess:public X-0165-thymine-X.inp -p 1
    time docker run --rm \
        --name=${instanceName} \
        -v ${local_docker_data1}:${docker_volume_data1} \
        ${imageTag} $input -p ${DOCKER_RUN_ARGS}
done

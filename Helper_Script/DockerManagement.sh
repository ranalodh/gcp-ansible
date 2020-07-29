#!/bin/bash
#*****************************************************************************
#
#Author:     Ranadip Lodh
#Purpose:    This shell script use to Stop all container and Remove all image and container
#Date:       20/04/2020
#
#*****************************************************************************

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker image prune -a -f
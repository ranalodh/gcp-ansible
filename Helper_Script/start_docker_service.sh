#!/bin/bash
#*****************************************************************************
#
#Author:     Ranadip Lodh
#Purpose:    This shell script use to Start Docker Service
#Date:       20/04/2020
#
#*****************************************************************************

service docker start
sudo chown $USER /var/run/docker.sock


#!/bin/bash
#*****************************************************************************
#
#Author:     Anirban Nandi
#Purpose:    This script check JPEG file count under a user defined folder.
#Date:       16/07/2020
#
#To run the shell script, following parameters need to pass
# $1   - Folder absolute path.
#
#*****************************************************************************

FILE_COUNT=`ls -lrt $1 | grep -v total | wc -l`

if [[ "${FILE_COUNT}" -gt "0" ]]; then
	FILE_LIST=`ls -lrt $1 | grep -v total | awk -F " " '{ print $NF }' | awk -F "." '{ print $1 }'`
    echo "PFA Job Monitor - Dashboard Error Report Files in DashboardErrorReport.zip. This Zip File consist of HTML Report and Snaps captured from Oozie Dashboard Error Logs."
	printf "\n"
	echo "Please find the Job Id (s) having with Error Logs"
	printf "\n"
	echo "${FILE_LIST}"
else
    echo "No Job Id found for Error Logs"
fi

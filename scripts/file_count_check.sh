#!/bin/bash
#*****************************************************************************
#
#Author:     Anirban Nandi
#Purpose:    This script identifies criticality for IndoSat file processing job.
#Date:       22/05/2020
#
#To run the shell script, following parameters need to pass
# $1   - date yyyymmdd format to check file processing status
# $2   - Indosat file processing job output file/content acts as input to this script
# $3   - Threshold value of number of file with Running status job,
#        Input should be given as RUNNING,<threshold_value>
# $4   - Threshold value of number of file with Waiting status job,
#        Input should be given as WAITING,<threshold_value>
# $5   - Threshold value of number of file with Finish status job,
#        Input should be given as FINISH,<threshold_value>
#
#        sh file_count_check.sh "20200518" "${INPUT}" "RUNNING,30904" "WAITING,16497" "FINISH,444826"
#        sh file_count_check.sh "20200518" "INDOSAT_INPUT.txt" "RUNNING,30904" "WAITING,16497" "FINISH,444826"
#*****************************************************************************

# Variable Declaration
DATE=$1
SCRIPT_OUTPUT_CONTENT=$2
RUNNING_THRESHOLD_VALUE=$3
WAITING_THRESHOLD_VALUE=$4
FINISH_THRESHOLD_VALUE=$5

if [ -f "${SCRIPT_OUTPUT_CONTENT}" ]
then
        INPUT_FILE_CONTENT=`cat ${SCRIPT_OUTPUT_CONTENT} | grep ${DATE}\|`
else
        INPUT_FILE_CONTENT=`echo "${SCRIPT_OUTPUT_CONTENT}" | grep ${DATE}\|`
fi

STATUS_R=`echo ${RUNNING_THRESHOLD_VALUE} | awk -F "," '{ print $1 }'`
THRESHOLD_VALUE_R=`echo $3 | awk -F "," '{ print $2 }'`
STATUS_W=`echo ${WAITING_THRESHOLD_VALUE} | awk -F "," '{ print $1 }'`
THRESHOLD_VALUE_W=`echo $4 | awk -F "," '{ print $2 }'`
STATUS_F=`echo ${FINISH_THRESHOLD_VALUE} | awk -F "," '{ print $1 }'`
THRESHOLD_VALUE_F=`echo $5 | awk -F "," '{ print $2 }'`

#
echo -e "NUMBER_OF_FILES \t\tFILE_PROCESSING_STATUS \t\tCRITICALITY";
echo -e "~~~~~~~~~~~~~~~ \t\t~~~~~~~~~~~~~~~~~~~~~~ \t\t~~~~~~~~~~~";

echo "${INPUT_FILE_CONTENT}" | while IFS= read -r ROW
do
        NUMBER_OF_FILES=`echo ${ROW} | awk -F "|" '{ print $2 }'`
        FILE_PROCESSING_STATUS=`echo ${ROW} | awk -F "|" '{ print $3 }' | awk -F " " '{ print $1 }'`
        #echo "FILE_PROCESSING_STATUS ${FILE_PROCESSING_STATUS} STATUS_R ${STATUS_R} NUMBER_OF_FILES ${NUMBER_OF_FILES} THRESHOLD_VALUE_R ${THRESHOLD_VALUE_R} FILE_PROCESSING_STATUS ${FILE_PROCESSING_STATUS} STATUS_W ${STATUS_W} NUMBER_OF_FILES ${NUMBER_OF_FILES} THRESHOLD_VALUE_W ${THRESHOLD_VALUE_W}"
        if [ "${FILE_PROCESSING_STATUS}" == "${STATUS_R}" ] && [ "${NUMBER_OF_FILES}" -ge "${THRESHOLD_VALUE_R}" ]
        then
                CRITICALITY_FLAG="TRUE"
                #return 1
        elif [ "${FILE_PROCESSING_STATUS}" == "${STATUS_W}" ] && [ "${NUMBER_OF_FILES}" -ge "${THRESHOLD_VALUE_W}" ]
        then
                CRITICALITY_FLAG="TRUE"
                #return 1
                elif [ "${FILE_PROCESSING_STATUS}" == "${STATUS_F}" ] && [ "${NUMBER_OF_FILES}" -ge "${THRESHOLD_VALUE_F}" ]
        then
                CRITICALITY_FLAG="TRUE"
                #return 1
        else
                CRITICALITY_FLAG="FALSE"
                #return 0
        fi
        if [ "${FILE_PROCESSING_STATUS}" == "WAITING" ] || [ "${FILE_PROCESSING_STATUS}" == "RUNNING" ]
        then
                echo -e "${NUMBER_OF_FILES} \t\t\t\t${FILE_PROCESSING_STATUS} \t\t\t${CRITICALITY_FLAG}";
        else
                echo -e "${NUMBER_OF_FILES} \t\t\t\t${FILE_PROCESSING_STATUS} \t\t\t\t${CRITICALITY_FLAG}";
        fi
done
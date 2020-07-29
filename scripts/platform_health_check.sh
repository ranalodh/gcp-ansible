#!/bin/bash
#*****************************************************************************
#
#Author:     Ranadip Lodh, Anirban Nandi
#Purpose:    This script captures server health details.
#Date:       29/04/2020
#
#To run the sheel script, following parameters need to pass
# $1   - Threshold value for CPU usage
# $2   - Threshold value for Disk space usage
# $3   - List of file system separated by pipe sign (i.e. |) will be excluded
#        in disk usage command
# $4   - Threshold value for I/O usage
# $5   - Threshold value for Memory usage
# $6   - Threshold value for Network usage
# $7   - List of file system separated by pipe sign (i.e. |) will be INCLUDED
# $8   - Is Frequent Alert require for threshold value - true/false 
#*****************************************************************************

threshold=0
itemType=""
alertType=$8
hostName=$(hostname --fqdn)
ipAddress=$(hostname -I)

cmpWithThreshold() {
  while read output;
  do
    #echo "$threshold $output"
    value=$(echo $output | awk '{print $1}' | cut -d'%' -f1)
    if [[ ${value%%.*} -gt ${threshold%%.*} ]]; then
       echo "$itemType $value is grater than the threshold value $threshold"
    elif [[ ${value%%.*} -lt ${threshold%%.*} ]]; then
       echo "$itemType $value is less than threshold value $threshold"
    else
       echo "$itemType $value is equal with threshold value $threshold"
    fi
  done
}

diskusageCmpWithThreshold() {
  while read output;
  do
    #echo "$threshold $output"
    usep=$(echo $output | awk '{print $1}' | cut -d'%' -f1)
    partition=$(echo $output | awk '{print $2}')
    if [[ $usep -gt $threshold ]]; then
       echo "$itemType $usep% of partition \"$partition\" is grater than the threshold value $threshold"
    elif [[ $usep -lt $threshold ]]; then
       echo "$itemType $usep% of partition \"$partition\" is less than threshold value $threshold"
    else
       echo "$itemType $usep% of partition \"$partition\" is equal with threshold value $threshold"
    fi
  done
}

if [[ $# -lt 8 ]]; then
   echo "Insufficient argument passed"
elif [ "$alertType" == false ]; then    
    divider="================================================================"
    printf "%s\n" "$divider"
    printf "%s\n" "SERVER HEALTH CHECK - $hostName - $ipAddress"
    dividerUnderline="----------------------------------------------------------------"
    printf "%s\n\n" "$dividerUnderline"

    divider1="~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

    #CPU usage

    printf "%s\n" "CPU usage"
    printf "%s\n" "$divider1"
    result=$(top -bn 1 -i -c)
    if [ -z "$1" ]; then
       printf "%s\n" "$result"
    else
       threshold=$1
       itemType="CPU usage value"
       #
       # adding us and sy value of "CPU(s)" row. where
       # us, user : time running un-niced user processes
       # sy, system : time running kernel processes
       #
       printf "%s" "$result"
       printf "%s\n"
       printf "%s" "$result" | grep -F "%Cpu" | awk '{print $2+$4}' | cmpWithThreshold
    fi

    #Disk space usage

    printf "\n%s\n" "Disk space usage"
    printf "%s\n" "$divider1"
    result=$(df -kh)
    if [ -z "$2" ]; then
       printf "%s\n" "$result"
    else
       excludeList=$3
       threshold=$2
       includeList=$7
       itemType="Disk space usage value"
       if [ -n "$excludeList" ] ; then
         # printf "%s" "$result"
         # echo ""
          printf "%s" "$result" | sed 1d | grep -vE "^${excludeList}" | grep -E "${includeList}" | awk '{print $5 " " $6 " " $1}' | diskusageCmpWithThreshold
       else
         # printf "%s" "$result"
         # echo ""
          printf "%s" "$result" | sed 1d | grep -E "${includeList}" | awk '{print $5 " " $6 " " $1}' | diskusageCmpWithThreshold
       fi
    fi

    #I/O usage

    printf "\n%s\n" "I/O usage"
    printf "%s\n" "$divider1"
    #result=$(iostat -c 1 2) #Show CPU only report with 1 seconds interval and 2 times reports
    result=$(iostat -c)
    if [ -z "$4" ]; then
       printf "%s\n" "$result"
    else
       threshold=$4
       itemType="I/O usage value"
       #
       # adding %user, %nice and %system value of "avg-cpu" rows(s). where
       # %user : percentage of CPU utilization that occurred while executing at the user (application) level
       # %nice : percentage of CPU utilization that occurred while executing at the user level with nice priority
       # %system : percentage of CPU utilization that occurred while executing at the system (kernel) level
       #
       printf "%s" "$result" | awk -F: '/avg-cpu:/ && $0 != "" { getline; print $0}' | awk '{print $1+$2+$3}' | cmpWithThreshold
    fi

        #Virtual memory

    printf "\n%s\n" "Virtual memory"
    printf "%s\n" "$divider1"
    result=$(vmstat -S m) #Show in Megabytes with parameters -S and m/M. By default vmstat displays statistics in kilobytes.
    if [ -z "$5" ]; then
       printf "%s\n" "$result"
    else
       threshold=$5
       itemType="Virtual memory free value"
       #comparing free value with threshold
       printf "%s" "$result"
       echo ""
       printf "%s" "$result" | awk -F: '/free/ && $0 != "" { getline; print $0}' | awk '{print $4}' | cmpWithThreshold
    fi

        #Network

    printf "\n%s\n" "Network"
    printf "%s\n" "$divider1"
    result=$(netstat)
    if [ -z "$6" ]; then
       printf "%s\n" "$result"
    else
       echo "Need to add compare logic"
    fi

    printf "\n\n%s\n" "$divider"
	
else
	
    #CPU Usage check
    cpu_threshold=$1
    disk_threshold=$2
    includeList=$7
    excludeList=$3

    cpuuse=$(cat /proc/loadavg | awk '{print $1}')        

	if [[ "$cpuuse" > $cpu_threshold ]]; then
		echo "***************   CPU Usage check on - $hostName - $ipAddress    ****************"
		echo "---------------------------------------------------------------------------------"
		echo "ATTENTION: CPU Load Is High on $(hostname) at $(date)"
	fi

	#Disk Space Usage check
	df -Ph | grep -E "${includeList}" | grep -vE "^${excludeList}" | awk '{ print $5,$1 }' | while read output;
	do
		#echo $output
		used=$(echo $output | awk '{print $1}' | sed s/%//g)
		partition=$(echo $output | awk '{print $2}')
		if [[ "$used" > $disk_threshold ]]; then
			echo "**********     Disk Space Usage check on - $hostName - $ipAddress     ***********"
            echo "---------------------------------------------------------------------------------"
			echo "ATTENTION: The partition \"$partition\" on $(hostname) has used $used% at $(date)"			
		fi

    done
fi
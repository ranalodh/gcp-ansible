#!/bin/bash
#*****************************************************************************
#
#Author:     Ranadip Lodh
#Purpose:    This shell script use to take Ansible AWX Backup
#Date:       20/04/2020
#$1          host/ip of Ansible Tower Server
#Backup      ./Backup_AWX 192.168.0.106
#Restore     tower-cli send backup.json 
#*****************************************************************************

yum install -y ansible-tower-cli
docker ps -a | grep awx_web
tower-cli config host http://$1:80
tower-cli config username admin
tower-cli config password password
tower-cli config verify_ssl 'false'
tower-cli receive --all > backup.json
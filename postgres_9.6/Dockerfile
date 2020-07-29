#*****************************************************************************
#
#Author:     Ranadip Lodh
#Purpose:    This Docker file use to install postgres container
#Date:       07/04/2020
#
#*****************************************************************************
FROM postgres:9.6

EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
#VOLUME /var/lib/postgresql/data
# Add VOLUMEs to allow backup of config, logs and databases
#VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

CMD ["postgres"]
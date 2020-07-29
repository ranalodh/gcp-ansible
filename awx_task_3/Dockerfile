#*****************************************************************************
#
#Author:     Ranadip Lodh
#Purpose:    This Docker file use to install awx_task container, ssh key pair.
#Date:       07/04/2020
#
#*****************************************************************************
FROM ansible/awx_task:3.0.0

ENV HOME "/root"

EXPOSE 8052

USER root

# Copy RSA keys (id_rsa & id_rsa.pub) for Ansible Playbook config repository (default keys).
# The public key (id_rsa.pub) should be added to https://github.ibm.com/IBMAutomation-DigitalWorker/indosat-ansible-playbook.git
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh
    
COPY key/id_rsa $HOME/.ssh/id_rsa
COPY key/id_rsa.pub $HOME/.ssh/id_rsa.pub

RUN chmod 600 $HOME/.ssh/id_rsa &&\
    chmod 600 $HOME/.ssh/id_rsa.pub
    
RUN echo "    IdentityFile $HOME/.ssh/id_rsa" >> /etc/ssh/ssh_config &&\
    echo "    StrictHostKeyChecking no      " >> /etc/ssh/ssh_config
    
RUN /bin/bash -c "eval '$(ssh-agent -s)'; ssh-add $HOME/.ssh/id_rsa;"
#!/bin/bash

SCRIPT=$(basename $0)
PID=$(pgrep ${SCRIPT})
LOG_FILE=/var/tmp/sandbox_config.${PID}.$(date +'%Y%m%d').log

log() {
  if [[ ! -r ${LOG_FILE} ]]
  then
    echo "[$(date)] Log file location: ${LOG_FILE}"
  fi
  echo "[$(date)] $@" | tee -a ${LOG_FILE}
}

log "Log started: $0"

if [[ -z "$(subscription-manager status | grep 'Overall Status: Current')" ]]
then
  log "ERROR> Ensure this system is registered to CDN before continuing."
  exit 1
fi

for PKG in ansible-core ansible-collection-redhat-rhel_mgmt
do
  if [[ -z "$(rpm -qa | grep ${PKG})" ]]
  then
    log "Installing ${PKG}."
    COMMAND="yum"
    if [[ "$(whoami)" != "root" ]]
    then
      log "This script is meant to be run as root, but we will try sudo here."
      COMMAND="sudo ${COMMAND}"
    fi
    ${COMMAND} install ${PKG} -y 2>&1 | tee -a ${LOG_FILE}
    if [[ -z "$(rpm -qa | grep ${PKG})" ]]
    then
      log "ERROR> Failed to install ${PKG}."
      exit 2
    fi
  fi
done

if [[ ! -r ~/.ssh/id_rsa ]]
then
  log "Generating a SSH key for Ansible to use."
  ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N '' 2>&1 | tee -a ${LOG_FILE}
fi

if [[ ! -d ~/ansible ]]
then
  log "Creating: ~/ansible"
  mkdir ~/ansible 2>&1 | tee -a ${LOG_FILE}
fi

if [[ ! -r ~/ansible/ansible.cfg ]]
then
  log "Creating basic ~/ansible/ansible.cfg"
  ansible-config init --disabled >~/ansible/ansible.cfg 
  sed -i 's/;become_user=.*/become_user=root/g' ~/ansible/ansible.cfg | tee -a ${LOG_FILE}
  sed -i 's/;inventory=.*/inventory=inventory/g' ~/ansible/ansible.cfg | tee -a ${LOG_FILE}
fi

if [[ ! -r ~/ansible/inventory ]]
then
  log "Creating basic ~/ansible/inventory"
  echo "kvm ansible_host=127.0.0.1" >~/ansible/inventory
fi

for GALAXY_MODULE in community.libvirt community.general
do
  log "Installing ${GALAXY_MODULE} with ansible-galaxy"
  ansible-galaxy collection install ${GALAXY_MODULE} 2>&1 | tee -a ${LOG_FILE}
done

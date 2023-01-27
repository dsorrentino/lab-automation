#!/usr/bin/env bash

MANIFEST_PATH=~/clusterconfigs/manifests

if [[ ! -d ${MANIFEST_PATH} ]]
then
  echo "Error> Missing manifests path: ${MANIFEST_PATH}"
  echo "       Execute this after generating the manifests."
  exit 1
fi

echo "Making masters schedulable in ~/clusterconfigs/manifests/cluster-scheduler-02-config.yml..." | tee -a ~/logs/masters_schedulable_.$(date +'%Y%m%d-%H%M').log
sed -i 's/mastersSchedulable: false/mastersSchedulable: true/g' ~/clusterconfigs/manifests/cluster-scheduler-02-config.yml

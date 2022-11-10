#!/usr/bin/env bash

OCP_RESOURCE=cluster

export XDG_CONFIG_HOME=$HOME/.cache/openshift-installer/image_cache/

~/binaries/openshift-baremetal-install --dir ~/clusterconfigs --log-level debug create ${OCP_RESOURCE} 2>&1 | tee -a ~/logs/create_${OCP_RESOURCE}.$(date +'%Y%m%d-%H%M').log

#!/usr/bin/env bash

OCP_RESOURCE=ignition-configs

~/binaries/openshift-baremetal-install --dir ~/clusterconfigs create ${OCP_RESOURCE} 2>&1 | tee -a ~/logs/create_${OCP_RESOURCE}.$(date +'%Y%m%d-%H%M').log

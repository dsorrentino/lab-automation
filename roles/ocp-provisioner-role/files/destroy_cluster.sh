#!/usr/bin/env bash

OCP_RESOURCE=cluster

~/binaries/openshift-baremetal-install --dir ~/clusterconfigs --log-level debug destroy ${OCP_RESOURCE} 2>&1 | tee -a ~/logs/destroy_${OCP_RESOURCE}.$(date +'%Y%m%d-%H%M').log

#!/bin/bash

~/binaries/openshift-baremetal-install --dir ~/clusterconfigs --log-level debug destroy cluster 2>&1 | tee -a ~/logs/destroy_cluster.$(date +'%Y%m%d-%H%M').log

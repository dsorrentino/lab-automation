#!/bin/bash

~/binaries/openshift-baremetal-install --dir ~/clusterconfigs --log-level debug create cluster 2>&1 | tee -a ~/logs/create_cluster.$(date +'%Y%m%d-%H%M').log

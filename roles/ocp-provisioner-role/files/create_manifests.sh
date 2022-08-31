#!/bin/bash

~/binaries/openshift-baremetal-install --dir ~/clusterconfigs create manifests 2>&1 | tee -a ~/logs/create_manifests.$(date +'%Y%m%d-%H%M').log

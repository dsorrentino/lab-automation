#!/usr/bin/env bash

MANIFEST_PATH=~/clusterconfigs/manifests

if [[ ! -d ${MANIFEST_PATH} ]]
then
  echo "Error> Missing manifests path: ${MANIFEST_PATH}"
  echo "       Execute this after generating the manifests."
  exit 1
fi

echo "Create ${MANIFEST_PATH}/cluster-network-avoid-workers-99-config.yaml to:"
echo "  - place ingressVIP on control plane nodes"
echo "  - deploy the following processes on the control plane nodes:"
echo "    - openshift-ingress-operator"
echo "    - keepalived"
echo ""
cat <<EOF >>${MANIFEST_PATH}/cluster-network-avoid-workers-99-config.yaml
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  name: 50-worker-fix-ipi-rwn
  labels:
    machineconfiguration.openshift.io/role: worker
spec:
  config:
    ignition:
      version: 3.2.0
    storage:
      files:
        - path: /etc/kubernetes/manifests/keepalived.yaml
          mode: 0644
          contents:
            source: data:,
EOF

cat <<EOF >>${MANIFEST_PATH}/cluster-ingress-default-ingresscontroller.yaml
apiVersion: operator.openshift.io/v1
kind: IngressController
metadata:
  name: default
  namespace: openshift-ingress-operator
spec:
  nodePlacement:
    nodeSelector:
      matchLabels:
        node-role.kubernetes.io/master: ""
EOF

echo "Setting masters to schedulable."
sed -i "s;mastersSchedulable: false;mastersSchedulable: true;g" ${MANIFEST_PATH}/cluster-scheduler-02-config.yml
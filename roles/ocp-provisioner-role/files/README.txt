This should be everything needed to deploy Baremetal Openshift using IPI.

The scripts are numbered in a general order of execution.  Scripts starting with 99_* are
optional helper scripts to help with common tasks outside of the deployment.

NOTE: When deploying the Bootstrap node, it looks like the networking does not get configured properly
even if the install-config.yaml has the correct IP addresses set for the External and Provisioning
networks.  Therefore, it is necessary to generate the iginition files and add the proper NIC configuration
to the ignition file of the bootstrap node.  

01_get_openshift.sh - This script when executed will pull down the specified version of Openshift as well
                      as the butane utility which you may or may not need to change your deployment configuration.

02_create_manifests.sh - This script will generate the manifests from the install-config.yaml located in ~/clusterconfigs

03_create_ignition.sh - This script will generate the ignition files from the configuration located in ~/clusterconfigs

04_fix_bootstrap_networking - This script will alter the bootstrap.ign file, changing the NIC configurations based on 
                              install_config.bootstrap* information you provided when you deployed the OCP Provisioner Role

05_ create_cluster.sh - This script will start the cluster creation process.

99_ destroy_cluster.sh - This script will destroy the cluster deployed using ~/clusterconfigs

99_clear_known_hosts.sh - This script deletes ~/.ssh/known_hosts.  Useful on re-deployments.

99_cleanup.sh - This script executes the previous two 99_* scripts as well as:
                Cleans up any virsh artifacts left behind from a failed deployment
                Ensures all baremetal nodes are powered off

99_create_image_cache.sh - Script to utilize a local OS Image Cache. Should be run before creating the manifests as it updates install-config.yaml

The overrides directory has configuration files for:

- Changing the NTP configuration of the Masters & Workers
- Adding networking components to the master nodes and making them schedulable (if you don't want to deploy workers)

NOTE: The proper place to do the overrides is AFTER creating the manifests but BEFORE creating the igntion files.
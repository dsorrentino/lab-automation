This should be everything needed to deploy Baremetal Openshift using IPI.

Directory:  baremetal_tools
Descripton: Contains a CSV file of the baremetal inventory and scripts to power on, power off and check power state of the baremetal nodes

Directory:   clusterconfigs
Description: This is the working directory for deploying Openshift.  Initially will contain your install-config.yaml

Directory:   initialconfigs
Description: This is the static directory where your install-config.yaml is located since performing the install consumes the install-config.yaml
             you will want to maintain the original/changes in this directory.  Initially will have the same install-config.yaml that is in clusterconfigs

Directory:   logs
Description: The scripts are all written to log into this directory

Directory:   helper_scripts
Description: This contains all of the scripts you will be executing to actually deploy Openshift. Here is a breakdown of the scripts contained within:

The scripts are numbered in a general order of execution.  Scripts starting with 99_* are optional helper scripts to help with common tasks outside 
of the deployment.

NOTE: When deploying the Bootstrap node in 4.11, it looks like the networking does not get configured properly even if the install-config.yaml has the
      correct  IP addresses set for the External and Provisioning networks.  Therefore, it is necessary to generate the iginition files and modify the 
      NIC configuration of the bootstrap node ignition file.  Testing in 4.12 showed that they fixed the NIC configuration issue, however it looked like
      DNS was not being properly configured.  The fix to bootstap networking below fixes both issues regardless of version.
      See: https://bugzilla.redhat.com/show_bug.cgi?id=2048600

01_get_openshift.sh - This script when executed will:
                        - Create a ~/binaries directory to store files
                        - Download the specified version of Openshift into ~/binaries
                        - Download the butane utility which you may or may not need to change your deployment configuration

02_create_manifests.sh - This script will generate the manifests from the install-config.yaml located in ~/clusterconfigs
                         After executing this, perform any overrides you may want to your deployment.
                         Example: Changing the NTP configuration of your cluster (see overrides directory below for more information)

03_create_ignition.sh - This script will generate the ignition files from the configuration located in ~/clusterconfigs
                        After executing this script, you will have ignition files in ~/clusterconfigs which you can then change using 
                        the butane utility

04_fix_bootstrap_networking - This script will alter the bootstrap.ign file, changing the NIC configurations based on 
                              install_config.bootstrap* information you provided when you deployed the OCP Provisioner Role

05_ create_cluster.sh - This script will start the cluster creation process.  You may want to execute this in a tmux session as it will run for about an hour.

99_ destroy_cluster.sh - This script will destroy the cluster deployed using ~/clusterconfigs

99_clear_known_hosts.sh - This script deletes ~/.ssh/known_hosts.  Useful on re-deployments.

99_cleanup.sh - This script executes the previous two 99_* scripts as well as:
                Cleans up any virsh artifacts left behind from a failed deployment
                Ensures all baremetal nodes are powered off
                Copies ~/initialconfigs/install_config.yml to ~/clusterconfigs

99_create_image_cache.sh - Script to utilize a local OS Image Cache. Should be run before creating the manifests as it updates install-config.yaml

Directory:   helper_scripts/overrides
Description: Contains deployment overrides that can be applied to the deployment manifests

The overrides directory has configuration files for:

- Making the master nodes schedulable
- Changing the NTP configuration of the Masters & Workers
- Adding networking components to the master nodes and making them schedulable (if you don't want to deploy workers)

NOTE: The proper place to do the overrides is AFTER creating the manifests but BEFORE creating the igntion files.
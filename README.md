# lab-automation

This project's purpose is to ease the deployment of Openshift Virtualization using an Installer Provisioned Infrastructure approach.  The set of playbooks will walk through the process of:

- Configuring a baremetal host as a KVM host
- Create a Virtual Machine to act as a utility server providing DNS and NTP to the Openshift deployed cluster
- Configure the baremetal KVM host to act as the OCP Provisioning node where the Openshift Boostrap VM will be launched
  - Generate a series of `baremetal tools` scripts to manually power on, power off and check power status of the baremetal hosts
  - Create a series of deployment `helper scripts` to aid in deploying Openshift Baremetal

# Usage

The scripts and playbooks are generally designed to be executed in numerical order.
Each of the playbooks has a series of variables defined in them which you should carefully review and change as needed
prior to execution.

High level flow:

- Register your baremetal host
- Cloning the repository
- Execute `00-setup.sh`

This will perform the following:
- Confirm baremetal host is registered
- Install ansible packages and `jq`
- Configure SSH Key for Ansible to use
- Create a basic `ansible.cfg` in ~/ansible
- Create a basic `inventory` file in ~/ansible
- Install pre-requisitesthe following from Ansible Galaxy
  - community.libvirt
  - community.general
  - ansible.posix

- Configure and execute playbook `01-configure_kvm.yml`
  - Example playbook configures 2 interfaces in a single bond with one tagged VLAN
    for the `baremetal` network
  - Native VLAN on both interfaces is that of the `provisioning` network
  - Two bridges are created, one for the `baremetal` network and one for the `provisioning` network

- Configure and execute playbook `02-create_vms.yml`
  - Example playbook creates a single virtual machine to be used as a `utility` server for deployment
  - You will want to change/configure your own Ansible Vault password file for the root password of
    the VM or optionally define `root_pw` with the plain-text password (not recommended)

- Configure and execute playbook `03-register_vms.yml`
  - Example playbook will require CDN credentials to register the vms created in the previous playbook
  - After registration, default repositories are configured on the vm

- Configure and execute playbook `04-configure_utility_vm.yml`
  - Example playbook will need to be updated with existing infrastructure services such as DNS and NTP servers
    to configure the vm with.
  - After configuring the VM for the existing infrastructure, this playbook will then configure the VM to provide
    NTP and DNS services to the Openshift Deployment. Pre-requisite DNS entries for the Openshift deployment will 
    be configured on the VM as part of the `nameserver-role`.

- Configure and execute playbook `05-configure_ocp_provisioner.yml`
  - Example playbook has some overlap with `01-configure_kvm.yml` which is controlled in the `configure_host` section
    - If you used `01-configure_kvm.yml`, you can effectively set all of the booleans to `no`
    - Your first `dns_servers` and `ntp_servers` should be the Utility VM you setup with `04-configure_utility_vm.yml`
    - There are serveral vault files defined which contain password & credential information.  Ensure you have your own
      vault file configured which should define the following variables:
        `baremetal_user`     - Used for IPMI to connect to baremetal nodes
        `baremetal_password` - Used for IPMI to connect to baremetal nodes
        `kni_user_password`  - Used when creating the `kni` user to run the deployment scripts
        `pull_secret`        - Used in configuring the basic `install-config.yaml` file

Once configured, you will want to switch to the `kni` user and continue with your deployment there. You will want to look
at `~/kni/READMNE.txt`
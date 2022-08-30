Role Name
=========

ocp-provisioner-role: Configures a system to act as the provisioner for an IPI OCP Installation

Requirements
------------

This role expects the target system is registered and has appropriate repositories configured. Additionally, it is expected that FirewallD is installed and running.

Role Variables
--------------

This role will create the user 'kni' on the target system.

kni_user_password: Password to use for the kni user
kni_use_provisioning_network: (boolean) if a provisioning network should be configured
kni_baremetal_interface: The non-bridged, default configured interface which the baremetal bridge will be built on
kni_provisioning_interface: The non-bridged, default configured interface which the provisioning bridge will be built on
kni_installer_version: The version that will be installed. This is only used in the ~kni/get_openshift.sh helper script.
install_config:
  base_domain: Base domain for the deployment
  cluster_name: OCP cluster name
  machine_network_cidr: External network CIDR
  provisioning_network_cidr: Provisioning network CIDR (Optional)
  bootstrap_ip: The IP given to the bootstrap node during IPI deployment
  bootstrap_gateway: The gateway used by the bootstrap node during IPI deployment
  api_vip: The API VIP for the OCP Cluster
  ingress_vip: The Wildcard IP for the OCP Cluster

Example Playbook
----------------

    - hosts: provisioner
      vars:
        kni_baremetal_interface: eth0
      vars_files:
        - vault/kni_password.yml
      roles:
        - ocp-provisioner-role

License
-------

BSD


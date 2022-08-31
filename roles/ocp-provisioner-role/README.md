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
  base_domain: Base domain for OCP Cluster
  cluster_name: OCP Cluster Name
  machine_network_cidr: Machine network CIDR
  provisioning_network_cidr: Provisioning network CIDR (Optional, kni_use_provisioning_network must be 'yes')
  bootstrap_ip: The IP address given to the boostrap deployment node
  bootstrap_gateway: The gateway given to the boostrap deployment node
  api_vip: The API VIP for the OCP cluster
  ingress_vip: The wildcard VIP for the OCP cluster
  hosts:
    ipmi_user: The user for IPMI to use when power controlling the nodes
    ipmi_password: The password for IPMI to use when power controlling the nodes
    master: This is the IPMI and MAC configuration of the OCP Master Nodes
      - { ipmi_ip: The IPMI IP address of the hardware node
          boot_mac: The MAC address of the boot NIC of the hardware node }
      - { ipmi_ip: The IPMI IP address of the hardware node
          boot_mac: The MAC address of the boot NIC of the hardware node }
      - { ipmi_ip: The IPMI IP address of the hardware node
          boot_mac: The MAC address of the boot NIC of the hardware node }
    worker: This is the IPMI and MAC configuration of the OCP Worker Nodes
      - { ipmi_ip: The IPMI IP address of the hardware node
          boot_mac: The MAC address of the boot NIC of the hardware node }
      - { ipmi_ip: The IPMI IP address of the hardware node
          boot_mac: The MAC address of the boot NIC of the hardware node }

Example Playbook
----------------

    - hosts: provisioner
      vars:
        kni_user_password: calvin
        kni_use_provisioning_network: false
        kni_baremetal_interface: eth0
        kni_provisioning_interface: eth1
        kni_installer_version: stable-4.11
        install_config:
          base_domain: example.com
          cluster_name: ocp
          machine_network_cidr: 192.168.0.0/24
          provisioning_network_cidr: 192.168.10.0/24
          bootstrap_ip: 192.168.0.100
          bootstrap_gateway: 192.168.0.1
          api_vip: 192.168.0.9
          ingress_vip: 192.168.0.10
          hosts:
            ipmi_user: root
            ipmi_password: calvin
            master:
              - { ipmi_ip: '192.168.99.100', boot_mac: 'AA:AA:AA:AA:AA:AA' }
              - { ipmi_ip: '192.168.99.101', boot_mac: 'BB:BB:BB:BB:BB:BB' }
              - { ipmi_ip: '192.168.99.102', boot_mac: 'CC:CC:CC:CC:CC:CC' }
            worker:
              - { ipmi_ip: '192.168.99.103', boot_mac: 'DD:DD:DD:DD:DD:DD' }
              - { ipmi_ip: '192.168.99.104', boot_mac: 'EE:EE:EE:EE:EE:EE' }
      vars_files:
        - vault/kni_password.yml
      roles:
        - ocp-provisioner-role

License
-------

BSD


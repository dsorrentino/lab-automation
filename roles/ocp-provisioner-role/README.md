Role Name
=========

ocp-provisioner-role: Configures a system to act as the provisioner for an IPI OCP Installation

Requirements
------------

This role expects the target system is registered and has appropriate repositories configured. Additionally, it is expected that FirewallD is installed and running.

Role Variables
--------------

This role will create the user 'kni' on the target system and configure the host to use IPI to deploy an OCP cluster.
A number of "helper scripts will be created that can be used to streamline the deployment.

configure_host:
  boolean:
    libvirtd: Should libvirtd be installed and configured. If yes, it will also configure the network interfaces to be able to launch the bootstrap node.
    firewalld: Whether the installer should add http to firewalld if you're opting to create an image cache.
  setting:
    baremetal_interface: If configuring libvirtd, this is the host interface connected to the baremetal network.
    provisioning_interface: If configuring libvirtd, this is the host interface connected to the provisioning network.
kni_user_password: Password to use for the kni user. Should store this in an Ansible Vault.
kni_use_provisioning_network: (boolean) if a provisioning network should be configured
kni_installer_version: The version that will be installed. This is only used in the ~kni/get_openshift.sh helper script to download the binaries.
install_config:
  base_domain: Base domain for OCP Cluster
  cluster_name: OCP Cluster Name
  machine_network_cidr: Machine network CIDR
  api_vip: The API VIP for the OCP cluster
  ingress_vip: The wildcard VIP for the OCP cluster
  external_bridge: Bridge name for the external network (Optional, defaults to "baremetal")
  provisioning_bridge: Bridge name for the provisioning network. (Optional, defaults to "provisioning")
  provisioning_network_cidr: Provisioning network CIDR (Optional, kni_use_provisioning_network must be 'yes')
  provisioning_dhcp_range: Provisioning network DHCP Range (Optional, kni_use_provisioning_network must be 'yes')
  bootstrap_external_ip: The IP address on the external (baremetal) network given to the boostrap deployment node
  bootstrap_external_prefix: The prefix for the external (baremetal) network given to the bootstrap deployment node
  bootstrap_external_gateway: The gateway on the external (baremetal) network given to the boostrap deployment node
  bootstrap_provisioning_ip: The IP address on the provisioning network given to the boostrap deployment node
  bootstrap_external_prefix: The prefix for the provisioning network given to the bootstrap deployment node
  bootstrap_dns_configuration: The DNS servers given to the bootstrap node, semicolon delimited, no spaces.  The first server listed is also configured on the cluster nodes when using NMState.
  baremetal:
    use_nmstate: Whether or not the NICs should be configured on the cluster hosts using NMState
    hosts: 
       - { role: Role for this node, may be "master" or "worker".
           role_index: Index of this node within the chosen role. Start at 0. 
           bmc_type: BMC type to configure, may be "ipmi" or "redfish". 
           bmc_ip: IP address of the BMC for this node.
           boot_mac: MAC address of the NIC on the provisioning network
           external_nic: Interface connected to the external (baremetal) network. Optional, used during NMstate application.
           provisioning_nic: Interface connected to the provisioning network. Optional, used during NMstate application. - Current bug exists that metal3 fails to configure when setting this.
           external_ip: IP address for the external (baremetal) NIC configuration. Used during NMstate application.
           provisioning_ip: IP address for the external provisioning NIC configuration. Used during NMstate application. 
           provisioning_vlan: VLAN ID for the provisioning network. Optional, when configured, a VLAN interface will be created off of provisioning_nic tagged with this vlan ID.
           external_vlan: VLAN ID for the external (baremetal) network. Optional, when configured, a VLAN interface will be created off of external_nic tagged with this vlan ID. 
          }
    
Example Playbook
----------------

- hosts: provisioner
  vars:
    configure_host:
      boolean:
        libvirt: no
        networking: no
        firewalld: no
        dns: yes
        ntp: yes
      setting:
        baremetal_interface: eth0
        provisioning_interface: eth1
    dns_servers:
      - 192.168.100.253
      - 192.168.100.252
      - 192.168.100.251
    ntp_servers:
      - 192.168.100.200
      - 192.168.100.201
      - 192.168.100.202
    kni_use_provisioning_network: true
    install_config:
      base_domain: example.com
      cluster_name: ocp
      external_bridge: br0
      machine_network_cidr: 192.168.200.0/24
      provisioning_bridge: br1
      provisioning_network_cidr: 172.16.10.0/24
      provisioning_dhcp_range: 172.16.10.50,172.16.10.100
      bootstrap_external_ip: 192.168.200.5
      bootstrap_external_prefix: 24
      bootstrap_external_gateway: 192.168.200.1
      bootstrap_provisioning_ip: 172.16.10.8
      bootstrap_provisioning_prefix: 24
      bootstrap_dns_configuration: 192.168.100.253;192.168.100.252;192.168.100.251;
      ntp_server_configuration: 192.168.100.200
      cluster_provisioning_nic: ens1
      api_vip: 192.168.200.11
      ingress_vip: 192.168.200.10
      baremetal:
        use_nmstate: true
        hosts:
          - { role: master, role_index: 0, bmc_type: redfish, bmc_ip: '192.168.50.100', boot_mac: 'AA:BB:CC:DD:EE:01', external_nic: ens0, external_ip: 192.168.200.20, external_vlan: 200 }
          - { role: master, role_index: 1, bmc_type: redfish, bmc_ip: '192.168.50.101', boot_mac: 'AA:BB:CC:DD:EE:02', external_nic: ens0, external_ip: 192.168.200.21, external_vlan: 200 }
          - { role: master, role_index: 2, bmc_type: redfish, bmc_ip: '192.168.50.102', boot_mac: 'AA:BB:CC:DD:EE:03', external_nic: ens0, external_ip: 192.168.200.22, external_vlan: 200 }
          - { role: worker, role_index: 0, bmc_type: redfish, bmc_ip: '192.168.50.103', boot_mac: 'AA:BB:CC:DD:EE:04', external_nic: ens0, external_ip: 192.168.200.30, external_vlan: 200 }
          - { role: worker, role_index: 1, bmc_type: redfish, bmc_ip: '192.168.50.104', boot_mac: 'AA:BB:CC:DD:EE:05', external_nic: ens0, external_ip: 192.168.200.31, external_vlan: 200 }
  vars_files:
    - vault/baremetal_credentials.yml
    - vault/kni_password.yml
    - vault/pull_secret.yml
  roles:
    - ocp-provisioner-role

License
-------

BSD


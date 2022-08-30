Role Name
=========

nameserver-role: A simple role to use dnsmasq as a nameserver

Requirements
------------

This role assumes FirewallD is installed and running.

Role Variables
--------------

dns_server_config:
  settings: Contains a list of name/value pairs which will be configured in the dnsmasq.conf file
  static_entries: Contains a list of name/ip pairs to configure /etc/hosts with
  wildcard_entries: Contains a list of domain/ip pairs to configure as wildcard entries

Dependencies
------------

ansible.posix

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      vars:
        ntp_allowed_network: 192.168.0.0/24
        dns_server_config:
          settings:
            - { name: "domain", value: "example.com" }
            - { name: "interface", value: "eth0" }
            - { name: "listen-address", value: "::1,127.0.0.1,192.168.0.254" }
          static_entries:
            - { name: server50.example.com, ip: 192.168.0.50 }
            - { name: server51.example.com, ip: 192.168.0.51 }
            - { name: api.ocp.example.com, ip: 192.168.0.9 }
            - { name: openshift-master-0.ocp.example.com, ip: 192.168.0.20 }
            - { name: openshift-master-1.ocp.example.com, ip: 192.168.0.21 }
            - { name: openshift-master-2.ocp.example.com, ip: 192.168.0.22 }
            - { name: openshift-worker-0.ocp.example.com, ip: 192.168.0.30 }
            - { name: openshift-worker-1.ocp.example.com, ip: 192.168.0.31 }
            - { name: openshift-worker-2.ocp.example.com, ip: 192.168.0.32 }
          wildcard_entries:
            - { domain: apps.ocp.example.com, ip: 192.168.0.10 }
      roles:
         - nameserver-role

License
-------

BSD


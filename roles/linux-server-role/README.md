Role Name
=========

linux-server-role: Update all packages, install and start FirewallD

Role Variables
--------------

dns_servers: A list of DNS Servers to configure to use
ntp_servers: A list of NTP Servers to configure to use

Dependencies
------------

This role expects that the system is already registered and has repositories configured.

Example Playbook
----------------

    - hosts: servers
      vars:
        dns_servers:
          - 192.168.0.252
          - 192.168.0.253
          - 192.168.0.254
        ntp_servers:
          - 192.168.0.252
          - 192.168.0.253
          - 192.168.0.254
      roles:
         - linux-server-role

License
-------

BSD


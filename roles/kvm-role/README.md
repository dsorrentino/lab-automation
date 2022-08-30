Role Name
=========

kvm-role: Configure localhost as a KVM host

Requirements
------------

This role expects:
  - localhost is the intended KVM host
  - localhost is registered and has repositories configured


Example Playbook
----------------

    - hosts: localhost
      roles:
        - kvm-role
    
License
-------

BSD


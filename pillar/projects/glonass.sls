include:
  - system-defaults

glonass-users:
  executor:
    shell: /bin/bash
    home: /home/executor
    password: !
    groups:
      - maintenance
  
glonass-directories:
  project_home:
    name: '/srv/glonass'
    owner: 'executor'
    group: 'maintenance'
    mode: '755'

glonass-system-configs:
  sysctl:
    net.core.somaxconn: '20480'
    net.core.wmem_max: '16777216'
    net.core.rmem_max: '16777216'
    net.ipv4.tcp_rmem: '4096 87380 16777216'
    net.ipv4.tcp_wmem: '4096 65536 16777216'
    net.ipv4.tcp_max_syn_backlog: '8192'
    net.ipv4.ip_nonlocal_bind: '1'
    net.ipv4.ip_forward:  '1'
  syslimits:
    nginx:
      nofiles: 8192

# CUSTOM PACKAGES 
glonass-custom-pkgs:  
  - python-virtualenv
  - python-pip
  - python-dev
  - libffi-dev
  - python-dev
  - libmariadbclient-dev

glonass-custom-configs:
#  nginx:
#    - 'nginx.conf'
#    - 'conf.d/.com.conf'
#  mongodb:
#    - 'mongodb.conf'
  keepalived:
    - 'keepalived.conf'


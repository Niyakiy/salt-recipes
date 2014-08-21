include:
  - system-defaults

wg-users:
  executor:
    shell: /bin/bash
    home: /home/executor
    password: !
    groups:
      - maintenance
  
wg-directories:
  project_home:
    name: '/srv/wg'
    owner: 'executor'
    group: 'maintenance'
    mode: '755'

wg-system-configs:
  sysctl:
    net.core.somaxconn: '20480'
    net.core.wmem_max: '16777216'
    net.core.rmem_max: '16777216'
    net.ipv4.tcp_rmem: '4096 87380 16777216'
    net.ipv4.tcp_wmem: '4096 65536 16777216'
    net.ipv4.tcp_max_syn_backlog: '8192'
  syslimits:
    nginx:
      nofiles: 8192


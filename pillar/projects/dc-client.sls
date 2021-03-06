include:
  - system-defaults

{% set prj_name = 'dc-client' %}

{{prj_name}}-users:
  executor:
    shell: /bin/bash
    home: /home/executor
    password: !
    groups:
      - maintenance
  
{{prj_name}}-directories:
  project_home:
    name: '/srv/{{prj_name}}'
    owner: 'executor'
    group: 'maintenance'
    mode: '755'

{{prj_name}}-sysctl:
  net.core.somaxconn: '20480'
  net.core.wmem_max: '16777216'
  net.core.rmem_max: '16777216'
  net.ipv4.tcp_rmem: '4096 87380 16777216'
  net.ipv4.tcp_wmem: '4096 65536 16777216'
  net.ipv4.tcp_max_syn_backlog: '8192'

{{prj_name}}-syslimits:
  nginx:
    nofiles: 8192

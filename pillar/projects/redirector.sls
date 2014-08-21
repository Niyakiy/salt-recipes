include:
  - system-defaults

{% set prj_name = "redirector" %}

{{prj_name}}-users:
  executor:
    shell: /bin/bash
    home: /home/executor
    password: !
    pub_key: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVwgFFCt28i/01aEddRJ5zjhjgaByM4Q78Vte1Bc64K7cA2E3eT9K6XMEowqETiOA1wLI4HAsSnGwzv6/z2BwWSHncdajGt0ySP0CBiELymmscUeGLMaGbb3govmEDb+xMVge8obBFWQmkQspWSXZQ/IvD5VOlPzkWeX3Hvctg1Jp+Qq5YmJcIk3e4h1a9bgCuxOzOgXoUIqqy58Lk8QelFMzHUDyQgji+riEani4IMarg2zVg0wMD8deXwpRdNyoiV2A2Fs0bPZKjk1lUKXN9JojyKoxeQEkwIwJzRkl8SbK4aUCqfJFjeYuY/k0SRq3ipZNJSnuBnN3pyUWcHOhr
    groups:
      - maintenance

{{prj_name}}-directories:
  project_home:
    name: '/srv/{{prj_name}}'
    owner: 'executor'
    group: 'maintenance'
    mode: '755'

  
{{prj_name}}-system-configs:
  sysctl:
    net.ipv4.ip_forward:  '1'
    net.ipv4.ip_nonlocal_bind: '1'
    net.core.somaxconn: '20480'
    net.core.wmem_max: '16777216'
    net.core.rmem_max: '16777216'
    net.ipv4.tcp_rmem: '4096 87380 16777216'
    net.ipv4.tcp_wmem: '4096 65536 16777216'
    net.ipv4.tcp_max_syn_backlog: '8192'
    vm.overcommit_memory: '1'
  syslimits:
    nginx:
      nofiles: 8192

{{prj_name}}-packages:
  - python-dev 
  - libmariadbclient-dev 
  - libffi-dev 
  - libxml2-dev 
  - libxslt-dev 
  - libpng12-dev 
  - libjpeg8-dev 
  - zlib1g-dev
  - python-virtualenv
  - libyaml-dev

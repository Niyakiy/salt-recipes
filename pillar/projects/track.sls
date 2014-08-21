include:
  - system-defaults

track-users:
  executor:
    shell: /bin/bash
    home: /home/executor
    password: !
    pub_key: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVwgFFCt28i/01aEddRJ5zjhjgaByM4Q78Vte1Bc64K7cA2E3eT9K6XMEowqETiOA1wLI4HAsSnGwzv6/z2BwWSHncdajGt0ySP0CBiELymmscUeGLMaGbb3govmEDb+xMVge8obBFWQmkQspWSXZQ/IvD5VOlPzkWeX3Hvctg1Jp+Qq5YmJcIk3e4h1a9bgCuxOzOgXoUIqqy58Lk8QelFMzHUDyQgji+riEani4IMarg2zVg0wMD8deXwpRdNyoiV2A2Fs0bPZKjk1lUKXN9JojyKoxeQEkwIwJzRkl8SbK4aUCqfJFjeYuY/k0SRq3ipZNJSnuBnN3pyUWcHOhr
    groups:
      - maintenance
  
track-system-configs:
  sysctl:
    net.ipv4.ip_forward:  1
    net.ipv4.ip_nonlocal_bind: 1
    net.core.somaxconn: '20480'
    net.core.wmem_max: '16777216'
    net.core.rmem_max: '16777216'
    net.ipv4.tcp_rmem: '4096 87380 16777216'
    net.ipv4.tcp_wmem: '4096 65536 16777216'
    net.ipv4.tcp_max_syn_backlog: '8192'
  syslimits:
    nginx:
      nofiles: 8192


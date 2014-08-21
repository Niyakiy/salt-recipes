include:
  - system-defaults

vio-wl-users:
  # deployment user
  deployer:
    shell: /bin/bash
    home: /home/deployer
    password: !
    pub_key: ssh-dss AAAAB3NzaC1kc3MAAACBAM9dAeS9uo3mD2t486+nVC+bhtIsiVjSxzYGwE8AJqgstz/1ViDony0gGrmfdr5BDa+MFqnEJ4ZbppCPbQRnlZvaxdPTKq43mq+JQRAyHGVe1ZbYsSzf9riE35ZGnE2+VdGBlLhmB1mNvQKdb9ZVkbGYTLP91eAHTYRcGGwwhzKdAAAAFQD/3/97Ch85FtR4MA60YBkNHRy1yQAAAIBdW4/kpoWFgo14SvaUwgZLbLlrtYahr+8DHOLBlr5cWzvzPXIvni/uf0iiiZiFgYTHqBxQTg5Y/O2Zf/heZm+3ZWSZ6heHlHsdhEywO9oIRG7eVVnQd5vP9iPj10iDj8UKPCZ+zCb/ty1sxNNchOSjUz8SbfyQK9Y4wpySDUJ52wAAAIEAxyC6pqgZq1ilP8KACCZpAWBc3J151pIGIagGFDOymEEbs/XAWW7E8YWZRr1IOzkjfI8UuxUAiUrXK/uW8DsgEn0btsTzEjpkANtpYgfuVipwM7iQjSJvuFkQZrvxYHkTqe6Dq9x+NG8nztiB8Zv6Ngm0KKHvEromn/mu/phEu9Q=
  # DEVOPS user
  mack:
    shell: /bin/bash
    home: /home/mack
    password: $6$Y4C.pvrEPs8J$g9waAV.Ul8JOM.8z3QWvWVn8tp4ueLzw1843ifDWIkuH8rEgTKXMe48vmPrc1XWitUgU1KEDCRt3RIoriyfhm.
    groups:
      - sudo
    configs:
      - .bashrc
      - .vimrc
      - .nginx.vim
      - .screenrc
  
vio-wl-system-configs:
  sysctl:
    net.core.somaxconn: '20480'
    net.core.wmem_max: '16777216'
    net.core.rmem_max: '16777216'
    net.ipv4.tcp_rmem: '4096 87380 16777216'
    net.ipv4.tcp_wmem: '4096 65536 16777216'
    net.ipv4.tcp_max_syn_backlog: '4096'
  syslimits:
    nginx:
      nofiles: 8192

vio-wl-custom-configs:
  nginx:
    - 'nginx.conf'
  mongodb:
    - 'mongodb.conf'

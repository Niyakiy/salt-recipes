include:
  - system-defaults

galaxyjorney-users:
  # deployment user
  deployer:
    shell: /bin/bash
    home: /home/deployer
    password: !
    pub_key: ssh-dss AAAAB3NzaC1kc3MAAACBAM9dAeS9uo3mD2t486+nVC+bhtIsiVjSxzYGwE8AJqgstz/1ViDony0gGrmfdr5BDa+MFqnEJ4ZbppCPbQRnlZvaxdPTKq43mq+JQRAyHGVe1ZbYsSzf9riE35ZGnE2+VdGBlLhmB1mNvQKdb9
  # DEVOPS user

  kilex:
    shell: /bin/bash
    home: /home/kilex
    password: $6$KPMGVA3c$rXIIpWzRLnsxbVTZpaGRYb783o6s1ZVBRxqSwB/Pgta3dCxGUcgDfPamUJhcB4KoIvkZKqz4NjLWeK9za.fdd1
    pub_key: ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAj0queCwEjRVY3r6ZS8A/EL7Q1F7tfvc2W0R08cvzdFgCMbEaoxQtFSVLgqG7E895SFIsh6zU/cslpGGyCZidAC906wiAe029oA9H6KRgH7BdXSpKjHMwP0ZgjhOyQEyXkB38EWjtE9+z9tBgpr6hY++ggUBhVHkMSztZWAdcN4U=
    groups:
      - sudo

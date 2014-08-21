sshd-package:  
  pkg.installed:
    - name: {{ salt['pillar.get']('pkg-names:openssh-server-pkg-name', 'openssh-server') }}

sshd-config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://__DEFAULT-CONFIGS/ssh/sshd_config
    - require:
      - pkg: sshd-package

sshd-service:
  service.running:
    - name: {{ salt['pillar.get']('service-names:ssh-service-name', 'ssh') }}
    - full_restart: True
    - require:
      - pkg: sshd-package
    - watch:
      - file: sshd-config

include:
  - debian_backports

haproxy:
  pkg.installed:
    - fromrepo: wheezy-backports
    - require:
      - pkgrepo: debian_backports
  service.running:

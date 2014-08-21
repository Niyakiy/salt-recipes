# BACKPORTS neded for install NODEJS

debian_backports:
  pkgrepo.managed:
    - humanname: debian-backports
    - name: deb http://ftp.us.debian.org/debian wheezy-backports main contrib non-free

nodejs_pkg:
  pkg.installed:
    - name: nodejs
    - required:
      - pkgrepo: debian_backports

nodejs_path_link:
  file.symlink:
    - name: /usr/bin/node
    - target: /usr/bin/nodejs

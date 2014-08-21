{% if grains['os'] == "Ubuntu" %}

docker_kernel:
  pkg.installed:
    - pkgs:
      - linux-image-generic-lts-raring
      - linux-headers-generic-lts-raring
    - require_in:
      - cmd: docker_kernel_reboot

docker_kernel_reboot:
  cmd.run:
    - name: sed -i "s/GRUB_DEFAULT=0/GRUB_DEFAULT=2/g" /etc/default/grub && update-grub && echo "docker installed" > /etc/docker.salt.state && reboot
    - unless: grep -q "docker installed" /etc/docker.salt.state
    - watch:
      - pkg: docker_kernel

docker_lxc_repo_key:
  cmd.run:
    - name: /usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
    - unless: /usr/bin/apt-key list | grep -q A88D21E9

docker_lxc_repo:
  pkgrepo.managed:
    - humanname: Docker Repo
    - name: deb http://get.docker.io/ubuntu docker main
    - require:
      - cmd: docker_lxc_repo_key
    - require_in:
      - pkg: docker_lxc_pkg

docker_lxc_pkg:
  pkg.installed:
    - name: lxc-docker
    - refresh: True
    - require:
      - pkgrepo: docker_lxc_repo
      - pkg: docker_kernel

{% endif %}

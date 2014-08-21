{% if grains['os'] == 'Debian' %}
hw-raid-monitoring-repo-gpg-key:
  cmd.run:
    - name: 'wget -O - http://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key | apt-key add -'
    - unless: 'apt-key list | grep -q 23B3D3B4'

hw-raid-monitoring-repo:
  pkgrepo.managed:
    - humanname: hwraid-repo
    - name: deb http://hwraid.le-vert.net/debian wheezy main
    - require:
      - cmd: hw-raid-monitoring-repo-gpg-key
{% endif %}

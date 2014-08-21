include:
  - default_pkgs

{% set default_conf_file = '__DEFAULT-CONFIGS/sudo/'+grains['os']+'/sudoers' -%}
{% if default_conf_file in salt['cp.list_master']() %}
sudo_config:
  file.managed:
    - name: /etc/sudoers
    - source: salt://{{ default_conf_file }}
    - mode: 440
    - user: root
    - group: root
    - require:
      - pkg: default_pkgs
{% endif %}

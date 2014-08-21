mariadb-repo-key-install:
  cmd.run:
    {% if grains['os'] == 'Debian' %}
    - name: 'apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db'
    - unless: 'apt-key list | grep -q 1BB943DB'
    {% else %}
    - name: echo "Unsupported system!"
    {% endif %}

mariadb-repo:
  pkgrepo.managed:
    - humanname: mariadb-repo
    - name: deb http://mariadb.mirror.triple-it.nl//repo/10.0/debian wheezy main
    - require_in:
      - pkg: mariadb-pkg
    - required:
      - cmd: mariadb-repo-key-install

mariadb-pkg:
  pkg.installed:
    - pkgs:
      - mariadb-galera-server
      - galera
    - refresh: True
    - require:
      - pkgrepo: mariadb-repo

{% set custom_config_present = False %}
{% set custom_conf_file = "__CUSTOM-CONFIGS/"+grains['id']+"/mariadb/my.cnf" %}
{% if custom_conf_file in salt['cp.list_master']() %}
{% set custom_config_present = True %}
{% endif %}

{% if custom_config_present %}
mariadb-config:
  file.managed:
    - name: /etc/mysql/my.cnf
    - source: salt://{{ custom_conf_file }}
    - require:
      - pkg: mariadb-pkg
{% endif %}

mariadb-service:
  service.running:
    - name: mysql
    - full_restart: True
    - enable: True
    - require:
      - pkg: mariadb-pkg
    {% if custom_config_present %}
    - watch:
      - file: mariadb-config
    {% endif %}

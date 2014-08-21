include:
  - resources.debian_backports

redis-server-pkg:   
  pkg.installed:
    - name: redis-server
    - fromrepo: wheezy-backports
    - refresh: True
    - require:
      - pkgrepo: debian_backports

{% set custom_conf_file = "__CUSTOM-CONFIGS/"+grains['id']+"/redis/redis.conf" -%}
{% if custom_conf_file in salt['cp.list_master']() %}

redis-server-config:  
  file.managed:
    - name: /etc/redis/redis.conf
    - source: salt://{{ custom_conf_file }}
    - require:
      - pkg: redis-server-pkg

redis-server-service:
  service.running:
    - name: redis-server
    - enable: True
    - full_restart: True
    - require:
      - pkg: redis-server-pkg
    - watch:
      - file: redis-server-config

{% endif %}

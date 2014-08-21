# getting all master files from forlders which name starts with "__" (default convention to store configs)
{% set all_master_configs = salt['cp.list_master'](prefix='__') %}

# checking per Project/minionID config location
{% if prj_name is defined and "__PROJECT_CONFIGS/"+prj_name+'/'+grains['id']+'/iptables/rules.v4' in all_master_configs %}
{% set custom_conf_file = "__PROJECT_CONFIGS/"+prj_name+'/'+grains['id']+'/iptables/rules.v4' %}

# checking per minionID config location
{% elif "__CUSTOM-CONFIGS/"+grains['id']+"/iptables/rules.v4" in all_master_configs %}
{% set custom_conf_file = "__CUSTOM-CONFIGS/"+grains['id']+"/iptables/rules.v4" %}
{% else %}

# using default config
{% set custom_conf_file = "__DEFAULT-CONFIGS/iptables/rules.v4" %}
{% endif %}

iptables-persistent-pkg:
  pkg.installed:
    - name: iptables-persistent

iptables-persistent-config:
  file.managed:
    - user: root  
    - group: root 
    - mode: 0640
    - name: /etc/iptables/rules.v4
    - source: salt://{{custom_conf_file}}
    - require:
      - pkg: iptables-persistent-pkg

iptables-persistent-service:
  service.running:
    - name: iptables-persistent
    - enable: True
    - reload: True
    - require:
      - pkg: iptables-persistent-pkg
      - file: iptables-persistent-config
    - watch: 
      - file: iptables-persistent-config


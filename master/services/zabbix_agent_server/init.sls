zabbix-agent-config:
  file.managed:
    - name: /etc/zabbix/zabbix_agentd.conf
    - source: salt://__DEFAULT-CONFIGS/zabbix/{{ grains['os'] }}/zabbix_agentd.conf
    - require:
      - pkg: zabbix-pkgs

{% set custom_config_present = False %}
{% set custom_conf_file = "__CUSTOM-CONFIGS/"+grains['id']+"/zabbix/zabbix_agentd.d/user_defined_params.conf" -%}
{% if custom_conf_file in salt['cp.list_master']() %}
{% set custom_config_present = True %}
zabbix-agent-config-userparams:
  file.managed:
    - name: /etc/zabbix/zabbix_agentd.d/user_defined_params.conf
    - source: salt://{{ custom_conf_file }}
    - require:
      - pkg: zabbix-pkgs
{% endif %}

zabbix-pkgs:
  pkg.installed:    
    - sources:
      {% if grains['os'] == 'Debian' %}      
      - zabbix-agent: http://repo.zabbix.com/zabbix/2.0/debian/pool/main/z/zabbix/zabbix-agent_2.0.11-1_{{ grains['osarch'] }}.deb
      {% elif grains['os'] == 'Ubuntu' %}
      - zabbix-agent: http://repo.zabbix.com/zabbix/2.0/ubuntu/pool/main/z/zabbix/zabbix-agent_2.0.11-1_amd64.deb
      {% elif grains['os'] == 'CentOS' %}
      - zabbix-agent: http://repo.zabbix.com/zabbix/2.0/rhel/6/x86_64/zabbix-2.0.11-1.el6.{{ grains['cpuarch'] }}.rpm
      - zabbix-agent: http://repo.zabbix.com/zabbix/2.0/rhel/6/x86_64/zabbix-agent-2.0.11-1.el6.{{ grains['cpuarch'] }}.rpm
      {% endif %}

zabbix-agent:
  service.running:
    - name: zabbix-agent
    - full_restart: True
    - watch:   
      - file: zabbix-agent-config
      {% if custom_config_present %}
      - file: zabbix-agent-config-userparams
      {% endif %}
      - pkg: zabbix-pkgs
    - require:
      - pkg: zabbix-pkgs

# DEFAULT services
include:
  - resources.__default_resources
  - services.__default_servers
  - services.keepalived_server
  - services.iptables_service
  - services.mariadb_server
  - services.nginx_server
  - services.beanstalkd_service
  - services.redis_server

{% set prj_name = "redirector" %}

# 
# SYSCTL configs
{% if 'sysctl' in pillar[prj_name+'-system-configs'] %}
{% for conf_opt in pillar[prj_name+'-system-configs']['sysctl'] %}
{{ prj_name }}-sysctl-{{ conf_opt }}:
  sysctl.present:
    - name: {{ conf_opt }}
    - value: {{ salt['pillar.get'](prj_name+'-system-configs:sysctl:'+conf_opt, '') }}
{% endfor %}
{% endif %} 
 

# ===== RESOURCES =============
# USERS

{% if prj_name+'-users' in pillar %}
{% for user_name in pillar[prj_name+'-users'] %}
{{ user_name }}:
  user.present: 
    {% if 'shell' in pillar[prj_name+'-users'][user_name] %}
    - shell: {{ salt['pillar.get'](prj_name+'-users:'+user_name+':shell', '/bin/bash') }}
    {% endif %}
    {% if 'home' in pillar[prj_name+'-users'][user_name] %}
    - home: {{ salt['pillar.get'](prj_name+'-users:'+user_name+':home', '/home/'+user_name) }}
    {% endif %}
    {% if 'password' in pillar[prj_name+'-users'][user_name] %}
    - password: {{ salt['pillar.get'](prj_name+'-users:'+user_name+':password', '!') }}
    {% endif %}
    {% if 'groups' in pillar[prj_name+'-users'][user_name] %}
    - groups:
      {% for group_name in pillar[prj_name+'-users'][user_name]['groups'] %}
      - {{ group_name }}
      {% endfor %}
    {% endif %}   

  {% if 'pub_key' in pillar[prj_name+'-users'][user_name] %}
  ssh_auth.present:
    - user: {{ user_name }}
    - name: {{ salt['pillar.get'](prj_name+'-users:'+user_name+':pub_key', '') }}
    - require:
      - user: {{ user_name }}
  {% endif %}

{% endfor %}
{% endif %} 


# DIRECTORIES
{% if prj_name+'-directories' in pillar %}
{% for dir in pillar[prj_name+'-directories'] %}
{{ prj_name }}-directory-{{ dir }}:
  file.directory:
    - name: {{ salt['pillar.get'](prj_name+'-directories:'+dir+':name', '') }}
    - user: {{ salt['pillar.get'](prj_name+'-directories:'+dir+':owner', '') }}
    - group: {{ salt['pillar.get'](prj_name+'-directories:'+dir+':group', '') }}
    - mode: {{ salt['pillar.get'](prj_name+'-directories:'+dir+':mode', '') }}
{% endfor %}
{% endif %}


# PACKAGES
{% if prj_name+'-packages' in pillar %}
{{ prj_name }}_packages:
  pkg.installed:
    - pkgs:
      {% for package in pillar[prj_name+'-packages'] %}
      - {{ package }}
      {% endfor %}
{% endif %} 

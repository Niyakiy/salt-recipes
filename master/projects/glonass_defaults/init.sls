# DEFAULT services
include:
  - resources.__default_resources
  - services.__default_servers
  - services.iptables_service
  - services.keepalived_server
  - services.redis_server

{% if 'glonass-custom-configs' in pillar %}
# KEEPALIVED configs
{% if 'keepalived' in pillar['glonass-custom-configs'] %}
{% for conf_file in pillar['glonass-custom-configs']['keepalived'] %}
glonass-keepalived-{{ conf_file }}:
  file.managed:
    - name: /etc/keepalived/{{ conf_file }}
    - source: salt://__CUSTOM-CONFIGS/{{ grains['id'] }}/keepalived/{{ conf_file }}
    - user: root    
    - group: root
    - mode: 644
{% endfor %}
{% endif %} 

# SYSCTL configs
{% if 'sysctl' in pillar['glonass-system-configs'] %}
{% for conf_opt in pillar['glonass-system-configs']['sysctl'] %}
glonass-sysctl-{{ conf_opt }}:
  sysctl.present:
    - name: {{ conf_opt }}
    - value: {{ salt['pillar.get']('glonass-system-configs:sysctl:'+conf_opt, '') }}
{% endfor %}
{% endif %} 

# ===== RESOURCES =============
# USERS
{% if 'glonass-users' in pillar %}
{% for user_name in pillar['glonass-users'] %}
{{ user_name }}:
  user.present:
    {% if 'shell' in pillar['glonass-users'][user_name] %}
    - shell: {{ salt['pillar.get']('glonass-users:'+user_name+':shell', '/bin/bash') }}
    {% endif %}
    {% if 'home' in pillar['glonass-users'][user_name] %}
    - home: {{ salt['pillar.get']('glonass-users:'+user_name+':home', '/home/'+user_name) }}
    {% endif %}
    {% if 'password' in pillar['glonass-users'][user_name] %}
    - password: {{ salt['pillar.get']('glonass-users:'+user_name+':password', '!') }}
    {% endif %}
    {% if 'groups' in pillar['glonass-users'][user_name] %}
    - groups:
      {% for group_name in pillar['glonass-users'][user_name]['groups'] %}
      - {{ group_name }}
      {% endfor %}
    {% endif %}

  {% if 'pub_key' in pillar['glonass-users'][user_name] %}
  ssh_auth.present:
    - user: {{ user_name }}
    - name: {{ salt['pillar.get']('glonass-users:'+user_name+':pub_key', '') }}
    - require:
      - user: {{ user_name }}
  {% endif %}

{% endfor %}
{% endif %}

# DIRECTORIES
{% if 'glonass-directories' in pillar %}
{% for dir in pillar['glonass-directories'] %}
glonass-directory-{{ dir }}:
  file.directory:
    - name: {{ salt['pillar.get']('glonass-directories:'+dir+':name', '') }}
    - user: {{ salt['pillar.get']('glonass-directories:'+dir+':owner', '') }}
    - group: {{ salt['pillar.get']('glonass-directories:'+dir+':group', '') }}
    - mode: {{ salt['pillar.get']('glonass-directories:'+dir+':mode', '') }}
{% endfor %}
{% endif %} 

# ===== EXTEND (1 per SLS) - ALL SERVICES ======
{% if 'glonass-custom-configs' in pillar %}
extend:
  # KEEPALIVED
  {% if 'keepalived' in pillar['glonass-custom-configs'] %}
  keepalived-service:
    service.running:
      - full_restart: True
      - watch:
        {% for conf_file in pillar['glonass-custom-configs']['keepalived'] %}
        - file: glonass-keepalived-{{ conf_file }}
        {% endfor %}
  {% endif %}
{% endif %}

{% endif %}

# PROJECT SPECIFIC 
{% if 'glonass-custom-pkgs' in pillar %}
glonass-custom-pkgs:
  pkg.installed:
    - pkgs:
    {% for package in pillar['glonass-custom-pkgs'] %}
      - {{ salt['pillar.get']('pkg-names:'+package+'-pkg-name', package) }}
    {% endfor %}
{% endif %}

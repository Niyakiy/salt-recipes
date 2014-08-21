# DEFAULT services
include:
  - resources.__default_resources
  - services.__default_servers
  - services.nginx_server
  - services.keepalived_server
  - services.mongodb_server
  - services.nodejs_package

# NGINX configs
{% if 'nginx' in pillar['ectrack-custom-configs'] %}
{% for conf_file in pillar['ectrack-custom-configs']['nginx'] %}
ectrack-nginx-{{ conf_file }}:
  file.managed:
    - name: /etc/nginx/{{ conf_file }}
    - source: salt://__CUSTOM-CONFIGS/{{ grains['id'] }}/nginx/{{ conf_file }}
    - user: root
    - group: root
    - mode: 644
{% endfor %}
{% endif %}


# MONGODB configs
{% if 'mongodb' in pillar['ectrack-custom-configs'] %}
{% for conf_file in pillar['ectrack-custom-configs']['mongodb'] %}
ectrack-mongodb-{{ conf_file }}:
  file.managed:
    - name: /etc/{{ conf_file }}
    - source: salt://__CUSTOM-CONFIGS/{{ grains['id'] }}/mongodb/{{ conf_file }}
    - user: root
    - group: root
    - mode: 644
{% endfor %}
{% endif %}


# KEEPALIVED configs
{% if 'keepalived' in pillar['ectrack-custom-configs'] %}
{% for conf_file in pillar['ectrack-custom-configs']['keepalived'] %}
ectrack-keepalived-{{ conf_file }}:
  file.managed:
    - name: /etc/keepalived/{{ conf_file }}
    - source: salt://__CUSTOM-CONFIGS/{{ grains['id'] }}/keepalived/{{ conf_file }}
    - user: root    
    - group: root
    - mode: 644
{% endfor %}
{% endif %} 


# SYSCTL configs
{% if 'sysctl' in pillar['ectrack-system-configs'] %}
{% for conf_opt in pillar['ectrack-system-configs']['sysctl'] %}
ectrack-sysctl-{{ conf_opt }}:
  sysctl.present:
    - name: {{ conf_opt }}
    - value: {{ salt['pillar.get']('ectrack-system-configs:sysctl:'+conf_opt, '') }}
{% endfor %}
{% endif %} 

# ===== RESOURCES =============
# USERS

{% if 'ectrack-users' in pillar %}
{% for user_name in pillar['ectrack-users'] %}
{{ user_name }}:
  user.present:
    {% if 'shell' in pillar['ectrack-users'][user_name] %}
    - shell: {{ salt['pillar.get']('ectrack-users:'+user_name+':shell', '/bin/bash') }}
    {% endif %}
    {% if 'home' in pillar['ectrack-users'][user_name] %}
    - home: {{ salt['pillar.get']('ectrack-users:'+user_name+':home', '/home/'+user_name) }}
    {% endif %}
    {% if 'password' in pillar['ectrack-users'][user_name] %}
    - password: {{ salt['pillar.get']('ectrack-users:'+user_name+':password', '!') }}
    {% endif %}
    {% if 'groups' in pillar['ectrack-users'][user_name] %}
    - groups:
      {% for group_name in pillar['ectrack-users'][user_name]['groups'] %}
      - {{ group_name }}
      {% endfor %}
    {% endif %}

  {% if 'pub_key' in pillar['ectrack-users'][user_name] %}
  ssh_auth.present:
    - user: {{ user_name }}
    - name: {{ salt['pillar.get']('ectrack-users:'+user_name+':pub_key', '') }}
    - require:
      - user: {{ user_name }}
  {% endif %}

{% endfor %}
{% endif %}

# DIRECTORIES
{% if 'ectrack-directories' in pillar %}
{% for dir in pillar['ectrack-directories'] %}
ectrack-directory-{{ dir }}:
  file.directory:
    - name: {{ salt['pillar.get']('ectrack-directories:'+dir+':name', '') }}
    - user: {{ salt['pillar.get']('ectrack-directories:'+dir+':owner', '') }}
    - group: {{ salt['pillar.get']('ectrack-directories:'+dir+':group', '') }}
    - mode: {{ salt['pillar.get']('ectrack-directories:'+dir+':mode', '') }}
{% endfor %}
{% endif %} 

# ===== EXTEND (1 per SLS) - ALL SERVICES ======
extend:
  # NGINX
  {% if 'nginx' in pillar['ectrack-custom-configs'] %}
  nginx-service:
    service.running:
      - full_restart: True
      - watch:
        {% for conf_file in pillar['ectrack-custom-configs']['nginx'] %}  
        - file: ectrack-nginx-{{ conf_file }}
        {% endfor %}
  {% endif %}

  # MONGODB
  {% if 'mongodb' in pillar['ectrack-custom-configs'] %}
  mongodb-service:
    service.running:
      - full_restart: True
      - watch:
        {% for conf_file in pillar['ectrack-custom-configs']['mongodb'] %}
        - file: ectrack-mongodb-{{ conf_file }}
        {% endfor %}
  {% endif %}

  # KEEPALIVED
  {% if 'keepalived' in pillar['ectrack-custom-configs'] %}
  keepalived-service:
    service.running:
      - full_restart: True
      - watch:
        {% for conf_file in pillar['ectrack-custom-configs']['keepalived'] %}
        - file: ectrack-keepalived-{{ conf_file }}
        {% endfor %}
  {% endif %}

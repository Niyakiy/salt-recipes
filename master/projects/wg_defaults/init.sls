# DEFAULT services
include:
  - resources.__default_resources
  - services.__default_servers


# SYSCTL configs
{% if 'sysctl' in pillar['wg-system-configs'] %}
{% for conf_opt in pillar['wg-system-configs']['sysctl'] %}
wg-sysctl-{{ conf_opt }}:
  sysctl.present:
    - name: {{ conf_opt }}
    - value: {{ salt['pillar.get']('wg-system-configs:sysctl:'+conf_opt, '') }}
{% endfor %}
{% endif %} 

# ===== RESOURCES =============
# USERS

{% if 'wg-users' in pillar %}
{% for user_name in pillar['wg-users'] %}
{{ user_name }}:
  user.present:
    {% if 'shell' in pillar['wg-users'][user_name] %}
    - shell: {{ salt['pillar.get']('wg-users:'+user_name+':shell', '/bin/bash') }}
    {% endif %}
    {% if 'home' in pillar['wg-users'][user_name] %}
    - home: {{ salt['pillar.get']('wg-users:'+user_name+':home', '/home/'+user_name) }}
    {% endif %}
    {% if 'password' in pillar['wg-users'][user_name] %}
    - password: {{ salt['pillar.get']('wg-users:'+user_name+':password', '!') }}
    {% endif %}
    {% if 'groups' in pillar['wg-users'][user_name] %}
    - groups:
      {% for group_name in pillar['wg-users'][user_name]['groups'] %}
      - {{ group_name }}
      {% endfor %}
    {% endif %}

  {% if 'pub_key' in pillar['wg-users'][user_name] %}
  ssh_auth.present:
    - user: {{ user_name }}
    - name: {{ salt['pillar.get']('wg-users:'+user_name+':pub_key', '') }}
    - require:
      - user: {{ user_name }}
  {% endif %}

{% endfor %}
{% endif %}

# DIRECTORIES
{% if 'wg-directories' in pillar %}
{% for dir in pillar['wg-directories'] %}
wg-directory-{{ dir }}:
  file.directory:
    - name: {{ salt['pillar.get']('wg-directories:'+dir+':name', '') }}
    - user: {{ salt['pillar.get']('wg-directories:'+dir+':owner', '') }}
    - group: {{ salt['pillar.get']('wg-directories:'+dir+':group', '') }}
    - mode: {{ salt['pillar.get']('wg-directories:'+dir+':mode', '') }}
{% endfor %}
{% endif %} 


# DEFAULT services
include:
  - resources.__default_resources
  - services.__default_servers
  - services.keepalived_server
  - services.iptables_service


# SYSCTL configs
{% if 'sysctl' in pillar['track-system-configs'] %}
{% for conf_opt in pillar['track-system-configs']['sysctl'] %}
ectrack-sysctl-{{ conf_opt }}:
  sysctl.present:
    - name: {{ conf_opt }}
    - value: {{ salt['pillar.get']('track-system-configs:sysctl:'+conf_opt, '') }}
{% endfor %}
{% endif %} 
 

# ===== RESOURCES =============
# USERS

{% if 'track-users' in pillar %}
{% for user_name in pillar['track-users'] %}
{{ user_name }}:
  user.present: 
    {% if 'shell' in pillar['track-users'][user_name] %}
    - shell: {{ salt['pillar.get']('track-users:'+user_name+':shell', '/bin/bash') }}
    {% endif %}
    {% if 'home' in pillar['track-users'][user_name] %}
    - home: {{ salt['pillar.get']('track-users:'+user_name+':home', '/home/'+user_name) }}
    {% endif %}
    {% if 'password' in pillar['track-users'][user_name] %}
    - password: {{ salt['pillar.get']('track-users:'+user_name+':password', '!') }}
    {% endif %}
    {% if 'groups' in pillar['track-users'][user_name] %}
    - groups:
      {% for group_name in pillar['track-users'][user_name]['groups'] %}
      - {{ group_name }}
      {% endfor %}
    {% endif %}   

  {% if 'pub_key' in pillar['track-users'][user_name] %}
  ssh_auth.present:
    - user: {{ user_name }}
    - name: {{ salt['pillar.get']('track-users:'+user_name+':pub_key', '') }}
    - require:
      - user: {{ user_name }}
  {% endif %}

{% endfor %}
{% endif %} 

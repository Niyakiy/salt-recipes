include:
  - resources.__default_resources
  - services.__default_servers

# USERS management

{% if 'wordstat-users' in pillar %}

{% for user_name in pillar['wordstat-users'] %}
{{ user_name }}:
  user.present: 
    {% if 'shell' in pillar['wordstat-users'][user_name] %}
    - shell: {{ salt['pillar.get']('wordstat-users:'+user_name+':shell', '/bin/bash') }}
    {% endif %}
    {% if 'home' in pillar['wordstat-users'][user_name] %}
    - home: {{ salt['pillar.get']('wordstat-users:'+user_name+':home', '/home/'+user_name) }}
    {% endif %}
    {% if 'password' in pillar['wordstat-users'][user_name] %}
    - password: {{ salt['pillar.get']('wordstat-users:'+user_name+':password', '!') }}
    {% endif %}    
    {% if 'groups' in pillar['wordstat-users'][user_name] %}
    - groups:
      {% for group_name in pillar['wordstat-users'][user_name]['groups'] %}
      - {{ group_name }}
      {% endfor %}
    {% endif %}   

  {% if 'pub_key' in pillar['wordstat-users'][user_name] %}
  ssh_auth.present:
    - user: {{ user_name }}
    - name: {{ salt['pillar.get']('wordstat-users:'+user_name+':pub_key', '') }}
    - require:
      - user: {{ user_name }}
  {% endif %}

  {% if 'configs' in pillar['wordstat-users'][user_name] %}
  {% for config_name in pillar['wordstat-users'][user_name]['configs'] %}
  file.managed:
    - name: /home/{{ user_name }}/{{ config_name }}
    - user: {{ user_name }}
    - group: {{ user_name }}
    - mode: 600
    - source: salt://__DEFAULT-CONFIGS/system_users/{{ user_name }}/{{ config_name }}
  {% endfor %}
  {% endif %} 

{% endfor %}

{% endif %}

# DEFAULT RESOURCES FOR ALL SYSTEMS

# GROUPS MANAGEMENT

{% if 'default-system-groups' in pillar %}
default_groups:  
  {% for sys_group_name in pillar['default-system-groups'] %}
  group.present:
    - name: {{ sys_group_name }}
  {% endfor %}
{% endif %}

# PACKAGE MANAGEMENT 

{% if 'default-system-pkgs' in pillar %}
default_pkgs:
  pkg.installed:
    - pkgs:
    {% for package in pillar['default-system-pkgs'] %}
      - {{ salt['pillar.get']('pkg-names:'+package+'-pkg-name', package) }}
    {% endfor %}
{% endif %}

# USERS MANAGEMENT

{% if 'default-system-users' in pillar %}

{% for user_name in pillar['default-system-users'] %}
{{ user_name }}_user:
  user.present:
    - name: {{ user_name }}
    {% if 'shell' in pillar['default-system-users'][user_name] %}
    - shell: {{ salt['pillar.get']('default-system-users:'+user_name+':shell', '/bin/bash') }}
    {% endif %}
    {% if 'home' in pillar['default-system-users'][user_name] %}
    - home: {{ salt['pillar.get']('default-system-users:'+user_name+':home', '/home/'+user_name) }}
    {% endif %}
    {% if 'password' in pillar['default-system-users'][user_name] %}
    - password: {{ salt['pillar.get']('default-system-users:'+user_name+':password', '!') }}
    {% endif %}    
    {% if 'groups' in pillar['default-system-users'][user_name] %}
    - groups:
      {% for group_name in pillar['default-system-users'][user_name]['groups'] %}
      - {{ group_name }}
      {% endfor %}
    {% endif %}

{% if 'pub_key' in pillar['default-system-users'][user_name] %}
{{ user_name }}_ssh_key:
  ssh_auth.present:
    - user: {{ user_name }}
    - name: {{ salt['pillar.get']('default-system-users:'+user_name+':pub_key', '') }}
    - require:
      - user: {{ user_name }}_user
{% endif %}

  {% if 'configs' in pillar['default-system-users'][user_name] %}
  {% for config_name in pillar['default-system-users'][user_name]['configs'] %}
{{ user_name }}_{{ config_name }}:
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

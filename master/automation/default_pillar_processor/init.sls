# DEFAULT PILLAR PROCESSOR

# check if there is normally pillar present
{% if 'prj_name' in pillar %}
{% set prj_name = pillar['prj_name'] %}

# ===================================
# Processing of SYSCTL parameters
# ===================================
{% if prj_name+'-sysctl' in pillar %}
{% for conf_opt in pillar[prj_name+'-sysctl'] %}
{{prj_name}}-sysctl-{{conf_opt}}:
  sysctl.present:
    - name: {{conf_opt}}
    - value: {{ pillar[prj_name+'-sysctl'][conf_opt] }}
{% endfor %}
{% endif %} 

# ===================================
# Processing of USERS section! 
# ===================================
{% if prj_name+'-users' in pillar %}
{% for user in pillar[prj_name+'-users'] %}
{{prj_name}}-user-{{user}}:
  user.present:
    - name: {{user}} 
    {% if 'shell' in pillar[prj_name+'-users'][user] %}
    - shell: {{ salt['pillar.get'](prj_name+'-users:'+user+':shell', '/bin/bash') }}
    {% endif %}
    {% if 'home' in pillar[prj_name+'-users'][user] %}
    - home: {{ salt['pillar.get'](prj_name+'-users:'+user+':home', '/home/'+user) }}
    {% endif %}
    {% if 'password' in pillar[prj_name+'-users'][user] %}
    - password: {{ salt['pillar.get'](prj_name+'-users:'+user+':password', '!') }}
    {% endif %}
    {% if 'groups' in pillar[prj_name+'-users'][user] %}
    - groups:
      {% for group_name in pillar[prj_name+'-users'][user]['groups'] %}
      - {{group_name}}
      {% endfor %}
    {% endif %}   

{% if 'pub_key' in pillar[prj_name+'-users'][user] %}
{{prj_name}}-user-{{user}}-sshkey:
  ssh_auth.present:
    - user: {{user}}
    - name: {{ salt['pillar.get'](prj_name+'-users:'+user+':pub_key', '') }}
    - require:
      - user: {{user}}
{% endif %}

{% endfor %}
{% endif %} 


# ===================================
# Processing of DIRECTORIES section!
# ===================================
{% if prj_name+'-directories' in pillar %}
{% for dir in pillar[prj_name+'-directories'] %}
{{prj_name}}-directory-{{dir}}:
  file.directory:
    - name:  {{ pillar[prj_name+'-directories'][dir]['name'] }}
    - user:  {{ pillar[prj_name+'-directories'][dir]['owner'] }}
    - group: {{ pillar[prj_name+'-directories'][dir]['group'] }}
    - mode:  {{ pillar[prj_name+'-directories'][dir]['mode'] }}
{% endfor %}
{% endif %} 


{% endif %}
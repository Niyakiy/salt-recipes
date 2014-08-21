{% for usr, args in pillar['users'].iteritems() %}

{{ usr }}:
  user.present:
    {% if 'shell' in args %}
    - shell: {{ args['shell'] }}
    {% endif %}
    {% if 'home' in args %}
    - home: {{ args['home'] }}
    {% endif %}
    {% if 'password' in args %}
    - password: {{ args['password'] }}
    {% endif %}
    {% if args['sudo_enabled'] %}
    - groups:      
      - {{ salt['pillar.get']('group-names:sudo-enabled-group-name', 'sudo') }}
    {% endif %}

  {% if 'pub_key' in args %}
  ssh_auth.present:
    - user: {{ usr }}
    - name: {{ args['pub_key'] }}
    - require: 
      - user: {{ usr }}
  {% endif %}

{% if 'bashrc' in args %}
{{ usr }}_bashrc:
  file.managed:
    - name: /home/{{ usr }}/.bashrc
    - user: {{ usr }}
    - group: {{ usr }}
    - source: salt://default_users/{{ usr }}/{{ args['bashrc'] }}
{% endif%}

{% if 'screenrc' in args %}
{{ usr }}_screenrc:
  file.managed:
    - name: /home/{{ usr }}/.screenrc
    - user: {{ usr }} 
    - group: {{ usr }}
    - source: salt://default_users/{{ usr }}/{{ args['screenrc'] }}
{% endif %}

{% endfor %}

{% for cnf in salt['cp.list_master'](prefix='__TST/') %}
{% set items = cnf.split('/') %}
nginx-config-{{ items|last }}:
  file.managed:
    - name: /etc/nginx/conf.d/{{ items|last }}
    - source: salt://{{ cnf }}
    - user: root
    - group: root
    - mode: 644
{% endfor %}

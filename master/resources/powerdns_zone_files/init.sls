{% if 'powerdns-zones' in pillar %}

include:
  - resources.__default_resources

{% if 'powerdns-zone-defaults' in pillar %}
{% set refresh = pillar['powerdns-zone-defaults']['refresh'] %}
{% set retry = pillar['powerdns-zone-defaults']['retry'] %}  
{% set expire = pillar['powerdns-zone-defaults']['expire'] %}
{% set minimum_ttl = pillar['powerdns-zone-defaults']['minimum_ttl'] %}
{% set default_ttl = pillar['powerdns-zone-defaults']['default_ttl'] %}
{% endif %}

powerdns-zone-files-dir:
  file.directory:
    - name: /var/pdns/
    - user: rsync-user
    - group: rsync-user
    - mode: 755
    - makedirs: True
    - required:
      - user: rsync-user

{% for domain_name in pillar['powerdns-zones'] %}

{% set auth_dns_name = 'ns1.'+domain_name %}
{% set admin_mail = 'admin.'+domain_name %}
{% set currdate = salt['cmd.run']('date +%Y%m%d') %}
{% set serial = currdate+'01' %}

powerdns-zone-{{ domain_name }}:
  file.managed:
    - name: /var/pdns/{{ domain_name }}
    - user: rsync-user
    - group: rsync-user
    - mode: 644  
    - template: jinja
    - source: salt://__TEMPLATES/powerdns/pdns_zone_file.jinja
    - required:
      - file: powerdns-zone-files-dir
    - context:
      domain_name: {{ domain_name }}
      refresh: {{ refresh }}
      default_ttl: {{ default_ttl }}
      retry: {{ retry }}
      expire: {{ expire }}
      minimum_ttl: {{ minimum_ttl }}
      auth_dns_name: {{ auth_dns_name }}
      admin_mail: {{ admin_mail }}
      serial: {{ serial }}
{% endfor %}
{% endif %}


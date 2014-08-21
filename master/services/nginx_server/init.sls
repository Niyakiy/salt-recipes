nginx-repo-key-install:
  cmd.run:
    {% if grains['os'] in ['Debian', 'Ubuntu'] %}
    - name: 'apt-key adv --keyserver keys.gnupg.net --recv-keys ABF5BD827BD9BF62'
    - unless: 'apt-key list | grep -q 7BD9BF62'
    {% else %}
    - name: echo "Unsupported system!"
    {% endif %}

nginx-repo:
  pkgrepo.managed:
    - humanname: nginx-repo
    - name: deb http://nginx.org/packages/mainline/debian/ wheezy nginx
    - require_in:
      - pkg: nginx-pkg
    - required:
      - cmd: nginx-repo-key-install

nginx-pkg:
  pkg.installed:
    - name: nginx
    - refresh: True
    - require:
      - pkgrepo: nginx-repo

{% set custom_config_present = False %}
{% set custom_conf_file = "__CUSTOM-CONFIGS/"+grains['id']+"/nginx/nginx.conf" -%}
{% if custom_conf_file in salt['cp.list_master']() %}
{% set custom_config_present = True %}
{% endif %}

{% if custom_config_present %}
nginx-main-config:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://{{ custom_conf_file }}
    - require:   
      - pkg: nginx-pkg
{% endif %}

{% set custom_vhost_config_present = False %}
{% for vhost_config in salt['cp.list_master'](prefix="__CUSTOM-CONFIGS/"+grains['id']+"/nginx/conf.d/") %}
{% set custom_vhost_config_present = True %}
{% set vhost_config_items = vhost_config.split('/') %}
nginx-vhost-config-{{ vhost_config }}:
  file.managed:
    - name: /etc/nginx/conf.d/{{ vhost_config_items|last }}
    - source: salt://{{ vhost_config }}
    - require:   
      - pkg: nginx-pkg
{% endfor %}


nginx-service:
  service.running:
    - name: nginx
    - full_restart: True
    - require:
      - pkg: nginx-pkg
    {% if custom_config_present or custom_vhost_config_present %}
    - watch:
      {% if custom_config_present %}
      - file: nginx-main-config
      {% endif %}
      {% if custom_vhost_config_present %}
      {% for vhost_config in salt['cp.list_master'](prefix="__CUSTOM-CONFIGS/"+grains['id']+"/nginx/conf.d/") %}
      - file: nginx-vhost-config-{{ vhost_config }}
      {% endfor %}
      {% endif %}
    {% endif %}


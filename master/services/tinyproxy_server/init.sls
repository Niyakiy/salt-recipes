tinyproxy-config:
  file.managed:
    {% if grains['os'] == 'Debian' %}
    - name: /etc/tinyproxy.conf
    {% elif grains['os'] == 'CentOS' %}
    - name: /etc/tinyproxy/tinyproxy.conf
    {% endif %}
    - source: salt://__DEFAULT-CONFIGS/tinyproxy/{{ grains['os'] }}/tinyproxy.conf
    - template: jinja
    - require:
      - pkg: tinyproxy-pkg
    

tinyproxy-pkg:
  pkg.installed:
    - name: tinyproxy

tinyproxy-service:
  service.running:
    - name: tinyproxy
    - full_restart: True
    - require:
      - pkg: tinyproxy-pkg
    - watch:
      - file: tinyproxy-config

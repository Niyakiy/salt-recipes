salt-pkgs:
  pkg.latest:
    - pkgs:
      - salt-minion
      {% if grains['os'] == 'Debian' %}
      - salt-common
      {% endif %}

salt-config-file:
  file.managed:
    - name: /etc/salt/minion
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: salt-pkgs

salt-service:
  service.running:
    - name: salt-minion
    - require:
      - file: salt-config-file
      - pkg: salt-pkgs
    - full_restart: True
    - watch:
      - file: salt-config-file

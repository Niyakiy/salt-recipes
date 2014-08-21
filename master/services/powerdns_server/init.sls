powerdns_config:
  file.managed:
    - template: jinja
    {% if grains['os'] == 'Debian' %}
    - name: /etc/powerdns/pdns.conf
    - source: salt://__DEFAULT-CONFIGS/powerdns/pdns.conf
    {% elif grains['os'] == 'CentOS' %}
    - name: /etc/pdns/pdns.conf
    - source: salt://powerdns/centos/pdns.conf
    {% endif %}

powerdns_pipe_backend:
  file.managed:
    {% if grains['os'] == 'Debian' %}
    - name: /etc/powerdns/pdns_pipe.py
    {% elif grains['os'] == 'CentOS' %}
    - name: /etc/pdns/pdns_pipe.py     
    {% endif %}
    - source: salt://__DEFAULT-CONFIGS/powerdns/pdns_pipe.py
    - user: root
    - group: root
    - mode: 755

powerdns_zones_dir:
  file.directory:
  - makedirs: True
  - name: /var/pdns
  - user: rsync-user
  - group: rsync-user
  - mode: 755
  - require: 
    - pkg: powerdns

powerdns_log_file:
  file.managed:
    - name: /var/log/pdns-query.log
    - user: pdns
    - group: pdns
    - touch: True
    - require:
      - cron: powerdns_log_cleanup

powerdns_log_cleanup:
  cron.present:
    - name: cat /dev/null > /var/log/pdns-query.log
    - hour: 2
    - minute: 30    

powerdns:
  pkg.installed:
    - pkgs:
      - pdns-server
      - pdns-backend-pipe  
  service.running:
    - name: pdns
    - full_restart: True
    - watch:
      - file: powerdns_config
      - file: powerdns_pipe_backend

10gen-repo:
  pkgrepo.managed:
    - humanname: 10gen-repo
    - name: deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen
    - keyid: 7F0CEB10
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: mongodb-pkg

pam_session_update:
  cmd.run:
    - name: "echo 'session required pam_limits.so' >> /etc/pam.d/common-session"
    - unless: 'grep -q "session required pam_limits.so" /etc/pam.d/common-session'

mongo_ulimits:
  file.managed:
    - name: /etc/security/limits.d/mongo-limits.conf
    - source: salt://__DEFAULT-CONFIGS/mongodb/mongo-limits.conf

mongodb-pkg:  
  pkg.installed:
    - name: mongodb-10gen
    - require:
      - pkgrepo: 10gen-repo

mongodb-service:
  service.running:
    - name: mongodb
    - full_restart: True
    - require:
      - pkg: mongodb-pkg
      - file: mongo_ulimits
      - cmd: pam_session_update
    - watch:
      - file: mongo_ulimits

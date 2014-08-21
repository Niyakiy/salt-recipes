rssh-pkg:
  pkg.installed:
    - name: rssh

rssh-config:
  file.managed:
    - name: /etc/rssh.conf
    - source: salt://__DEFAULT-CONFIGS/rssh/rssh.conf
    - require:
      - pkg: rssh-pkg

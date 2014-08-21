beanstalkd-pkg:
  pkg.installed:
    - name: beanstalkd


beanstalkd-enabler:
  file.managed:
    - name: /etc/default/beanstalkd
    - source: salt://__DEFAULT-CONFIGS/beanstalkd/etc-defaults-beanstalkd
    - require:
      - pkg: beanstalkd-pkg

beanstalkd-service:
  service.running:
    - name: beanstalkd
    - full_restart: True
    - require:
      - pkg: beanstalkd-pkg
    - watch:
      - file: beanstalkd-enabler

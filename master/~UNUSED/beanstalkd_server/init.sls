beanstalkd:
  pkg.installed:    
    - sources:
      {% if grains['os'] == 'Debian' %}
      - beanstalkd: salt://beanstalkd_server/beanstalkd_1.9-1_amd64.deb
      {% elif grains['os'] == 'CentOS' %}
      - beanstalkd: salt://beanstalkd_server/beanstalkd_1.9-1_amd64.deb
      {% endif %}
  service.running:
    - full_restart: True

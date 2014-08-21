rabbitmq-repo-key-install:
  cmd.run:
    {% if grains['os'] in ['Debian', 'Ubuntu'] %}
    - name: 'wget -qO - http://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add -'
    - unless: 'apt-key list | grep -q RabbitMQ'
    {% else %}
    - name: echo "Unsupported system!"
    {% endif %}

rabbitmq-repo:
  pkgrepo.managed:
    - humanname: rabbitmq-repo
    - name: deb http://www.rabbitmq.com/debian/ testing main
    - require_in:
      - pkg: rabbitmq-pkg
    - required:
      - cmd: rabbitmq-repo-key-install

rabbitmq-pkg:
  pkg.installed:
    - name: rabbitmq-server
    - refresh: True
    - require:
      - pkgrepo: rabbitmq-repo

rabbitmq-service:
  service.running:
    - name: rabbitmq-server
    - require:
      - pkg: rabbitmq-pkg

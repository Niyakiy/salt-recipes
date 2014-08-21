# DEFAULT services
include:
  - services.nginx_server

# Custom CONFIGS
{% if 'glonass-custom-configs' in pillar %}
# NGINX configs
{% if 'nginx' in pillar['glonass-custom-configs'] %}
{% for conf_file in pillar['glonass-custom-configs']['nginx'] %}
glonass-nginx-{{ conf_file }}:
  file.managed:
    - name: /etc/nginx/{{ conf_file }}
    - source: salt://__CUSTOM-CONFIGS/{{ grains['id'] }}/nginx/{{ conf_file }}
    - user: root
    - group: root
    - mode: 644
{% endfor %}

# ===== EXTEND (1 per SLS) - ALL SERVICES ======
extend:
  nginx-service:
    service.running:
      - full_restart: True
      - watch:
        {% for conf_file in pillar['glonass-custom-configs']['nginx'] %}
        - file: glonass-nginx-{{ conf_file }}
        {% endfor %}
{% endif %}
{% endif %}
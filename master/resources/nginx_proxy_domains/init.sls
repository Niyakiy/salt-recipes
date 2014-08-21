{% if 'nginx-proxy-domains' in pillar %}
include:
  - services.nginx_server

{% for domain_info in pillar['nginx-proxy-domains'] %}
nginx-proxy-{{ domain_info }}:

  {% set bind_address = salt['pillar.get']('nginx-proxy-domains:'+domain_info+':bind_address', '80') %}
  {% set server_names = salt['pillar.get']('nginx-proxy-domains:'+domain_info+':server_names', '_') %}
  {% set proxy_address = salt['pillar.get']('nginx-proxy-domains:'+domain_info+':proxy_address', '127.0.0.1:80') %}

  file.managed:
    - name: /etc/nginx/conf.d/{{ domain_info }}.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://__TEMPLATES/nginx/{{ salt['pillar.get']('nginx-proxy-domains:template_file_name', 'simple_proxy.jinja') }}
    - required:
      - pkg: nginx-pkg
    - context:
      bind_address: {{ bind_address }}
      server_names: {{ server_names }}
      proxy_address: {{ proxy_address }}
{% endfor %}
{% endif %}

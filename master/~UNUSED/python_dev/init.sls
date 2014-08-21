{% for package in pillar['python_dev'] %}
{{ package }}:
  pkg.installed
{% endfor %}

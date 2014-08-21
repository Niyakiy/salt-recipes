default_pkgs:
  pkg.installed:
    - pkgs: 
    {% for package in pillar['default-pkgs'] %}
      - {{ salt['pillar.get']('pkg-names:'+package+'-pkg-name', package) }}
    {% endfor %}


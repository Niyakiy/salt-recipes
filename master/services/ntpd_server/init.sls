ntpd-pkg:
  pkg.installed:
    - name: ntp
  
ntpd-service:
  service.running:
    - name: {{ salt['pillar.get']('service-names:ntp-service-name', 'ntp') }}
    - require:
      - pkg: ntpd-pkg

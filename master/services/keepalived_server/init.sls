keepalived-pkg:
  pkg.installed:
    - name: keepalived

keepalived-service:
  service.running:
    - name: keepalived
    - required:
      - pkg: keepalived-pkg

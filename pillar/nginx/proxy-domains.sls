nginx-proxy-domains:

  # domain names collection
  __test.com:
    # template file to use
    template_file_name: 'simple_proxy.jinja'
    # Network information - ip:port to bind (optional, [listen 80;] will be used if bind_address undef)
    bind_address: 127.0.0.1:80
    # Server names (collection one per line)
    server_names: 'test.com www.test.com m.test.com'
    # Endpoint proxy network info - ip:port
    proxy_address: 127.0.0.1:8080

  __test2.com:
    template_file_name: 'simple_proxy.jinja'
    server_names: 'test2.com www.test2.com m.test2.com'
    proxy_address: 127.0.0.1:8080

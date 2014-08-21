# Common parameters for all domains
powerdns-zone-defaults:
  refresh: 10800  
  retry: 3600        
  expire: 604800   
  minimum_ttl: 3600
  default_ttl: 3600

powerdns-zones:
# Domains collection with all records as collection
# "__root" record means @ for domain
  test.com:
    ns1: 123.123.123.123
    ns2: 234.234.234.234
    __root: 1.2.3.4
    www: 1.2.3.4
    m: 2.2.2.2

  test2.com:
    ns1: 222.222.222.222
    ns2: 234.234.234.234
    __root: 1.2.3.4
    www: 1.2.3.4
    m: 2.2.2.2

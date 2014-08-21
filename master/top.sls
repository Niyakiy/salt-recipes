base:

# ===== TESTING SERVER =====
  'eu.tst-proxy.tst-mysql-db.dns':
    - services.tst

# ============================
# Misc sevices configuration
# ============================

  'colaboration.srv':
    - resources.__default_resources
    - services.__default_servers

  'eu.mainsat.fromfr':
    - resources.__default_resources
    - services.__default_servers


# ============================
# PROXY configuration
# ============================
  'eu.02.pve.proxy,eu.03.pve.proxy.dns.satholder,eu.04.proxy,ru.01.pve.proxy.dns.satholder,ru.02.proxy,us.01.pve.proxy,us.02.pve.proxy.dns.satholder,us.03.pve.proxy.dns.satholder,us.04.pve.proxy.dns.satholder,us.05.pve.proxy.dns.satholder':
    - match: list
    - resources.__default_resources
    - services.__default_servers
    - services.tinyproxy_server

# ============================
# TRACK configuration
# ============================  
  'Track*':
    - projects.track_defaults
  'Track-App*':
    - projects.track_app
  'Track-RabbitMQ*':
    - projects.track_mq
  

# ============================
# WORDSTAT configuration
# ============================
  '*wstat*':
    - projects.wordstat_defaults

# ============================
# GALAXY JORNEY configuration
# ============================
  '*gj*':
    - projects.galaxyjorney_defaults

# ============================
# VIO-WL configuration
# ============================
  '*vio-wl*':
    - projects.vio-wl_defaults

# ============================
# GLONASS configuration
# ============================
  'glonass*':
    - projects.glonass_defaults
    - projects.glonass_db
  'glonass.app*':
    - projects.glonass_app

# ============================
# WG configuration
# ============================
  'wg*':
    - projects.wg_defaults

# ============================
# SATELLITES configuration
# ============================
  'satellites':
    - projects.satellites_defaults


# ============================
# ZABBIX configuration 
# ============================
  'zabbix':  
    - resources.__default_resources
    - services.__default_servers

# ============================
# CALL-CENTER configuration 
# ============================
  'callstation.mysql.asterisk':  
    - projects.callcenter

# ============================
# WL-NEW configuration
# ============================
  'wl-new':
    - resources.__default_resources
    - services.nginx_server

  'vu3_vk.app':
    - resources.__default_resources
    - services.__default_servers

# ===================================
# REDIRECTOR (NEDOBAN) configuration
# ===================================
  'redirector*':
    - projects.redirector_defaults

# ===================================
# SocialAuto PHP configuration 
# ===================================
  'sa.php.app.mq.1':
    - projects.social_auto

# ===================================
# Offline CAS configuration 
# ===================================
  'offline-cas*':
    - resources.__default_resources
    - services.__default_servers
    - services.nginx_server

# ===================================
# EC-Proxy configuration
# ===================================
  'ecproxy.app01':
    - projects.ecproxy_app

# ===================================
# SAPA services configuration
# ===================================
  'sapa.*':
    - projects.sapa-defaults

# ===================================
# Common PHP projects settings
# ===================================
  'php.*':
    - resources.__default_resources
    - services.__default_servers

# ===================================
# WL Downloadable client
# ===================================
  'dc-client':
    - projects.dc-client

# ===================================
# ASTERISK defaults
# ===================================
  'asterisk.hetzner.centos':
    - resources.__default_resources
    - services.__default_servers

# ===================================
# WLDATA defaults
# ===================================
  'wldata.postgre.hetzner':
    - resources.__default_resources
    - services.__default_servers

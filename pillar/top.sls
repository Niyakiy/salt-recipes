base:

# ALL SYSTEM default pillars
  '*':
    - system-namings
    - system-defaults

# SERVICES Specific pillars
  '*proxy*':
    - tinyproxy.allowed-ips

  '*dns*':
    - powerdns.zones-data

# PROJECTS Specific pillars
  '*track*':
    - projects.ectrack

  '*wstat*':
    - projects.wordstat

  '*gj*':
    - projects.galaxyjorney

  '*vio-wl*':
    - projects.vio-wl

  '*glonass*':
    - projects.glonass

  'wg*':
    - projects.wg

  'Track*':
    - projects.track

  'redirector*':
    - projects.redirector

  'ecproxy*':
    - projects.ecproxy

  'dc-client':
    - projects.dc-client

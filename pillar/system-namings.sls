service-names:
  {% if grains['os'] in ['Debian', 'Ubuntu'] %}
  ssh-service-name: ssh
  apache-service-name: apache2
  ntp-service-name: ntp
  {% elif grains['os'] == 'CentOS' %}
  ssh-service-name: sshd
  apache-service-name: httpd
  ntp-service-name: ntpd
  {% endif %}

pkg-names:
  {% if grains['os'] in ['Debian', 'Ubuntu'] %}
  vim-pkg-name: vim
  apache-pkg-name: apache2  
  {% elif grains['os'] == 'CentOS' %}
  vim-pkg-name: vim-enhanced
  apache-pkg-name: httpd
  {% endif %}

group-names:
  {% if grains['os'] in ['Debian', 'Ubuntu'] %}
  sudo-enabled-group-name: sudo
  {% elif grains['os'] == 'CentOS' %}
  sudo-enabled-group-name: wheel
  {% endif %}

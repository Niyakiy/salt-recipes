# DEFAULT GROUPS FOR ALL SERVERS
default-system-groups:
  - maintenance

{% if grains['os'] in ['Debian', 'Ubuntu'] %}
{% set sudo_group = 'sudo' %}
{% else %}
{% set sudo_group = 'wheel' %}
{% endif %}

# DEFAULT USERS FOR ALL SERVERS
default-system-users: 
  root:
    default: True
    shell: /bin/bash
    password: $6$83zwivU0$QpjsVQptBjt81UFiw4M/YNYhcPdGsCDVF0BBnKAFxX2Pcdmc9pQyBAGPmlRQPwaiGUxr.IBxR4yS/5FOhyoD0.
 
  rsync-user:
    default: True
    shell: /bin/bash
    home: /home/rsync-user
    password: $6$7BL0HfGmHYXD3$nrAKayfhXObrtjEqHxfTxE2IQfjUfl0.DRnV/Zk.pzXkuNj4cTIJa1t/3iMXDwZbJxXjAFakNtsd62zhpnLVN.
    pub_key: ssh-dss AAAAB3NzaC1kc3MAAACBALqa29lx7pGLJdKQLpWR2io8YXLvtItSR9ByduBtm+TSlW1DyxI81DmfoDtAsb3GRkS1yHsr3M6KLCK4RuwPuytnEPayqiVmW6K90+6tALSkjAtMe7KGw5lilIQB/gI6+3kSQN2yNzNofrEXJmO4MhBfTzfeL1XdhoNQ6XIhg3vHAAAAFQDC940Fid3d+QgYikOIAUhgmSX06wAAAIEAuHW/JOZ8QwkIPgnjFSrGjAQeZNvD+g9hs505oBRVXnxQx35VaRw7DXcAbbMUq0rGxaq+e58OPhEBKfmRieHOpuI6uHFr4PSOWIjlaKZcj5oKaD9p0ZTwKzR5NacEOttxspZblj5qYHClsZmfckDYmx1RIDdhAEd9RzJPrWHsWE4AAACAJ1L1ChHXW98P+tqYk+xJpgWgDfnhOVIybHFy8vsWUHaYaWuogRiJgffbwNtUcdwBKQ4Qr4mtyGIjkeHawGDV0zmKrAm6sWJeEPqPnWzvDTbhgKtuXa8x3iXI19QemfBeC2l77G/0UrNuxULtWgu2wPSAdmmpUHspmEtY394kx6Y=
    groups:
      - maintenance

  eugene:
    default: True
    shell: /bin/bash
    home: /home/eugene
    password: $6$EF2Ascjo$J7PKfbp1rrArcQGAfK.PftaYju5DM/YSRGFw1HnNT7Y/d1OsTpFNIulwjYNovu6y/mDH0y5utwCgblzSvRRzo1
    pub_key: ssh-dss AAAAB3NzaC1kc3MAAACBAOUJfFBiwSji+Qpb8Z6RjUYiX/WgzzsnI9KXZoban0+XSqpczsGIxfUDVW5GD0ZYCXvbmuLy1vus10K1fhSm6TiyxHxAx9uWazM0yniVg7lCoPzNUTPnJN+Z5qd0mL1eQUkfkFVVbKt3vBk7xnVPP/Z/Ku0jrsyf3WJBqripU77LAAAAFQDB0LUNzsqy42Rxd8TFoLgfQVEfTwAAAIEAxQsx5LK27oQDL6iMZbHCVvSvYDAe9UNQovBNu+oA046odIraJtY6vB0zswDRl3XDSn0UvvGYLR54UAI0GKejW9LyEgUcqs0D7w/E0HV3Rdbl8g7FCsyUSfF97LSpCyRxOvtHhGwUWLZ3VwQRsLen9WsybWGPJuvjQGpy7g+SK5cAAACBALK7KPs6JsDDrJ8+0zi7ILjU3m9QfZFJJNUrUgk7iIw86ST6Zy7a954ezXXgZbtQ0SZB7m6ALLMZj3+97Bvs4AtTXpKPfjDAHH4IX8sQ7/8UjxZ1+eVFK764TgiWegVfsk34Ho+MXonrCs+javunP0XoWSSKk9dYwhx5Ikd+bMag
    groups:
      - {{ sudo_group }}
    configs:
      - .bashrc
 
  turbid:
    default: True
    shell: /bin/bash
    home: /home/turbid
    password: $6$Mf/..04p$gzrDg7nT5mTyrWrEf2uLQ9EdQluqRDfaIfBV9gMrt507qbaC.iCWbU9khuCZfLpk5cxz2ixPIbt62LqJdj1eb/
    pub_key: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCw2WRiJF+xHR9alkBMiaty7MikmZLdtIYMgGqJK83sQDi64vSfafSN19pVFDTQhjQHWPVcjb9K3RYL5Vv7uBfI9hKW5wCGDo957V7g0dSVX6Movxcj/HzefmlU01k7FzORChjB6LQAWalf7BJ+xRLItoGYYeMckMv0sOdMKWDAehKXa3Kum8IpO5o3ZnnzS0CrYLFc6vGusbh/mc0WBIC22dGrxDGjTN90yHFGv8N3FB/ys21+lvVt+fBhTwpTQ9lnaJ9jPVthWoQVSBFqkaSF6dwDXS22XiQf3a+24PAajYMrU1XawuzUr+Y6rqzhq8kP1D0kACt/AoXNcOEkk9ud 
    groups:
      - {{ sudo_group }}
    configs:
      - .bashrc
      - .screenrc

# DEFAULT REPOSITORIES FOR ALL SYSTEMS
#default-system-repos:

# DEFAULT PACKAGES FOR ALL SYSTEMS
default-system-pkgs:
  - sudo
  - screen
  - mc
  - joe
  - fail2ban
  - dstat
  - rssh
  - htop
  - python-pycurl
  - curl
  - pbzip2
  - sudo
  - vim
  {% if grains['os'] == 'Debian' %}
  - python-apt
  - python-software-properties
  - chkconfig
  {% endif %}

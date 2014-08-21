mack:
  user.present:
    - shell: /bin/bash
    - home: /home/mack
    - password: $6$Y4C.pvrEPs8J$g9waAV.Ul8JOM.8z3QWvWVn8tp4ueLzw1843ifDWIkuH8rEgTKXMe48vmPrc1XWitUgU1KEDCRt3RIoriyfhm.
    - groups:
      - sudo

mack_bashrc:
  file.managed:
    - name: /home/mack/.bashrc
    - user: mack
    - group: mack
    - source: salt://user_mack/.bashrc

mack_vimrc: 
  file.managed:
    - name: /home/mack/.vimrc
    - user: mack      
    - group: mack     
    - source: salt://user_mack/.vimrc

mack_nginx.vim:  
  file.managed:
    - name: /home/mack/.nginx.vim
    - user: mack      
    - group: mack     
    - source: salt://user_mack/.nginx.vim

mack_screenrc:
  file.managed:
    - name: /home/mack/.screenrc
    - user: mack 
    - group: mack
    - source: salt://user_mack/.screenrc

## Playbook en profundidad

En este capitulo vamos a instalar wordpress utilizando ansible

### Instalar modulos de la comunidad

```shell
make requirements
```

### Crear Playbook

```yaml
---
- name: Wordpress Install
  hosts: demo
  become: true
  gather_facts: true

  vars:
    mysql_root_password: mypassword
    wordpress_user: wordpress
    wordpress_password: mywordpress_pass
    wordpress_db_name: wp_db

  tasks:
    - name: Update Packages
      ansible.builtin.apt:
        update_cache: yes
        upgrade: dist

    - name: Install Apache2
      ansible.builtin.apt:
        name: apache2
        state: present

    - name: Start Apache service
      ansible.builtin.systemd_service:
        name: apache2
        state: started
        enabled: true

    - name: Install php and dependencies
      ansible.builtin.apt:
        name: "{{ item }}"
        state: present
      loop:
        - php
        - php-common
        - php-mysql
        - php-xml
        - php-xmlrpc
        - php-curl
        - php-gd
        - php-imagick
        - php-cli
        - php-dev
        - php-dev
        - php-imap
        - php-mbstring
        - php-opcache
        - php-soap
        - php-zip
        - php-intl

    - name: Install MariaDB
      ansible.builtin.apt:
        name:
          - mariadb-server
          - mariadb-client
        state: present

    - name: Start MariaDB service
      ansible.builtin.systemd_service:
        name: mariadb
        state: started
        enabled: true

    - import_tasks: python.yaml

    - name: Set MariaDB root password
      community.mysql.mysql_user:
        name: root
        host: localhost
        password: "{{ mysql_root_password }}"
        login_user: root
        login_password: ""
        priv: "*.*:ALL,GRANT"
        state: present
      ignore_errors: true

    - name: Remove anonymous MariaDB users
      community.mysql.mysql_user:
        name: ""
        host_all: yes
        login_user: root
        login_password: "{{ mysql_root_password }}"
        state: absent

    - name: Disallow root login remotely
      community.mysql.mysql_user:
        name: root
        host: "{{ item }}"
        login_user: root
        login_password: "{{ mysql_root_password }}"
        state: absent
      loop:
        - "{{ ansible_hostname }}"
        - "::1"
        - "127.0.0.1"
        - "%"

    - name: Remove test database
      community.mysql.mysql_db:
        name: test
        state: absent
        login_user: root
        login_password: "{{ mysql_root_password }}"

    - name: Reload privilege tables
      ansible.builtin.command: mysql -u root -p"{{ mysql_root_password }}" -e "FLUSH PRIVILEGES;"

    - name: Add wordpress database
      community.mysql.mysql_db:
        name: "{{ wordpress_db_name }}"
        state: present
        login_user: root
        login_password: "{{ mysql_root_password }}"

    - name: Set wordpress user and password
      community.mysql.mysql_user:
        name: "{{ wordpress_user }}"
        host: localhost
        password: "{{ wordpress_password }}"
        login_user: root
        login_password: "{{ mysql_root_password }}"
        priv: "{{ wordpress_db_name }}.*:ALL,GRANT"
        state: present

    - name: Download wordpress
      ansible.builtin.get_url:
        url: https://wordpress.org/wordpress-6.6.1.tar.gz
        dest: /tmp

    - name: Extract wordpress
      ansible.builtin.unarchive:
        src: /tmp/wordpress-6.6.1.tar.gz
        dest: /var/www/html
        remote_src: true

    - name: Generate new wp-config
      ansible.builtin.copy:
        remote_src: true
        src: /var/www/html/wordpress/wp-config-sample.php
        dest: /var/www/html/wordpress/wp-config.php

    - name: Change wordpress permission
      ansible.builtin.file:
        path: /var/www/html
        state: directory
        recurse: yes
        owner: www-data
        group: www-data
        mode: "0755"

    - name: Configure wp-config.php
      ansible.builtin.lineinfile:
        path: /var/www/html/wordpress/wp-config.php
        regexp: "{{ item.regexp }}"
        line: "{{ item.line }}"
      no_log: True
      loop:
        - {
            regexp: "database_name_here",
            line: "define('DB_NAME', '{{ wordpress_db_name }}');",
          }
        - {
            regexp: "username_here",
            line: "define('DB_USER', '{{ wordpress_user }}');",
          }
        - {
            regexp: "password_here",
            line: "define('DB_PASSWORD', '{{ wordpress_password }}');",
          }

    - name: Add wordpress secret key generator
      ansible.builtin.shell: |
        curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/html/wordpress/wp-config.php

    - name: Generate Wordpress apache conf
      ansible.builtin.copy:
        remote_src: true
        src: /etc/apache2/sites-available/000-default.conf
        dest: /etc/apache2/sites-available/wordpress.conf

    - name: Add wordpress DocumentRoot
      ansible.builtin.lineinfile:
        path: /etc/apache2/sites-available/wordpress.conf
        regexp: "/var/www/html"
        line: "        DocumentRoot /var/www/html/wordpress"

    - name: Enable wordpress site
      ansible.builtin.shell: |
        a2ensite wordpress.conf
        a2dissite 000-default.conf
      args:
        chdir: /etc/apache2/sites-available

    - name: Restart Apache2 service
      ansible.builtin.systemd_service:
        name: apache2
        state: restarted
```

### Notas

- Fijate como hemos agregad `gather_facts: true` para que nos devuelva la información de nuestro servidor remoto. Esto esta habilitado por defecto.
- Podemos instalar varios paquetes en secuencia usando `loop` y asignando una variable `"{{ item }}"` para que lo ejecute de forma secuencial.
- Podemos importar tareas durante la ejecucion de un playbook. Ejemplo `import_tasks: python.yaml`

### Tip

Si deseas checkear que tu playbook esta correcto sin tener que ejectarlo, puedes usar `ansible-playbook --check wordpress.yml`

### Ejecutar playbook

```shell
ansible-playbook -i inventory.ini wordpress.yml
```

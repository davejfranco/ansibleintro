## Vamos a crear Roles para Wordpress

En ansible los roles son una forma de agrupar tareas. Esto no permite organizar y poder reutilizar nuestro codigo.

Vamos a crear un directorio que contenga nuestros roles `mkdir roles`

### Estructura de roles

Esta es la estructura que deben tener nuestros roles Ansible

```shell
mariadb
├── defaults
├── files
├── handlers
│   └── main.yaml
├── tasks
│   ├── main.yaml
│   └── python.yaml
├── templates
└── vars
└── vars.yaml
```

- defaults/: Contiene las variables predeterminadas del role. Estas variables tienen la prioridad más baja, es decir, pueden ser sobrescritas por otras definiciones de variables.

- files/: Aquí se colocan los archivos que serán copiados al servidor destino tal como están, sin modificaciones. Ansible usa el módulo copy o fetch para mover estos archivos.

- handlers/: Define los manejadores, que son tareas especiales que se ejecutan solo cuando son notificadas. Los handlers suelen usarse para reiniciar servicios después de que se hayan realizado cambios en la configuración.

- tasks/: Es la parte central del role. Aquí se definen las tareas (en un archivo llamado main.yml u otros archivos que pueden ser incluidos), que describen las acciones que realizará Ansible en los hosts gestionados.

- templates/: En este directorio se colocan plantillas que serán procesadas con el motor de plantillas Jinja2. Las plantillas son archivos de texto que pueden contener variables que serán reemplazadas en tiempo de ejecución.

- vars/: Aquí se definen variables que tienen una prioridad mayor que las definidas en defaults/. Estas variables suelen ser utilizadas en tareas, plantillas y manejadores.

### Crear Roles

Vamos a crear dos roles, uno para nuestra base de datos mariadb en este caso, y otro para nuestro sitio wordpress

```shell
mkdir roles/mariadb
mkdir roles/wordpress
```

Para cada role, podemos copiar los pasos de nuestro playbook wordpress y agregarlos como un archivo main.yaml al directorio tasks del role correspondiente.

Ejemplo: `roles/mariadb/tasks/main.yaml`

````yaml
- name: Install MariaDB
  ansible.builtin.apt:
    name:
      - mariadb-server
      - mariadb-client
    state: present
  notify: Start MariaDB

- name: Ensure Python Dependencies
  ansible.builtin.import_tasks: python.yaml

- name: Set MariaDB root password
  community.mysql.mysql_user:
    name: root
    host: localhost
    password: "{{ new_root_password }}"
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
    login_password: "{{ new_root_password }}"
    state: absent

- name: Disallow root login remotely
  community.mysql.mysql_user:
    name: root
    host: "{{ item }}"
    login_user: root
    login_password: "{{ new_root_password }}"
    state: absent
  loop:
    - "{{ ansible_hostname }}"
    - '::1'
    - '127.0.0.1'
    - '%'

- name: Remove test database
  community.mysql.mysql_db:
    name: test
    state: absent
    login_user: root
    login_password: "{{ new_root_password }}"

- name: Reload privilege tables
  ansible.builtin.command: mysql -u root -p"{{ new_root_password }}" -e "FLUSH PRIVILEGES;"

```yaml
- name: Ensure Python Dependencies
  ansible.builtin.import_tasks: python.yaml
````

Este archivo debe estar dentro del directorio tasks para que pueda funcionar.

### Playbook wordpress v2

Una vez que hayamos migrado nuestro playbook a los roles, deberemos invocarlos.

```yaml
---
- name: Wordpress Install V2
  hosts: demo
  become: True

  roles:
    - role: wordpress
      vars:
        mysql_root_password: mypassword
        wordpress_user: wordpress_user
        wordpress_db_name: wp-db
        wordpress_password: mywppassword
```

### Nota

Todo el codigo creado durante el curso esta en el directory `src/` en este proyecto.

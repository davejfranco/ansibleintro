## Playbooks

En Ansible un playbook es una secuencia de tareas que se ejecutan en el servidor que estamos administrando y utilizamos yaml para describir dichos pasos.


### Crear playbook 

```yaml
---
- name: Hello World
  hosts: localhost
  connection: local

  tasks:
    - name: Hello World
      ansible.builtin.shell: "echo 'Hello World'"
```
Lo importante que debes notar es lo siguiente:
- El nombre del playbook 
- El host, en este caso localhost es nuestra propia maquina
- La configuracion de la conexion, en este caso local
- Las tareas que queremos ejecutar

### Ejecutar playbook

Para ejecutar el playbook

```bash
ansible-playbook hello.yaml 
```

### Un playbook mas complejo

```yaml
---
- name: Update server 
  hosts: demo 
  
  tasks:
    - name: Update all packages on server
      ansible.builtin.apt:
        name: '*'
        state: latest
      become: true
```

Hemos agregado "become" este argumento, es el equivalente a decir `sudo apt update`. Puede agregarse por tarea o en el playbook.

### Instalar un paquete

```yaml
---
- name: Install apache2
  hosts: demo
  become: true

  tasks:

    - name: Update all packages on server
      ansible.builtin.apt:
        name: '*'
        state: latest
    
    - name: Install apache2
      ansible.builtin.apt:
        name: apache2
        state: latest

    - name: Start apache2
      ansible.builtin.service:
        name: apache2
        state: started
```

En esta oportunidad, hemos instalado apache2 y hemos iniciado el servicio. 
Para comprobar que hemos instalado el paquete, podemos ejecutar el siguiente comando:

```bash
curl -I http://[ip de vm]
```


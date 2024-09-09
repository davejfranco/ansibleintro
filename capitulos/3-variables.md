## Variables

En ansible las variables nos permite modificar el comportamiento de los playbooks. Existen distintas formas de definirlas.

### En archivo de inventarios
```yaml
all:
  vars:
    ansible_user: ubuntu
```

### En playbooks
```yaml
---
- name: Hello World
  hosts: localhost
  connection: local

  vars:
    user: DaveOps 
  
  tasks:
    - name: Hello World
      ansible.builtin.debug: 
        msg: "Hello World! {{ user }}"
```

### En linea de comandos
```bash
ansible-playbook -e "user=DaveOps" hello.yaml
```



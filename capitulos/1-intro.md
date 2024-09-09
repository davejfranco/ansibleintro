# Intro a Ansible

Ansible es un software para instalar, configurar y ejecutar operaciones en un sistema operativo.
Es lo que se conoce como sistema de gestión de configuración o "Configuration Management" en inglés. Esta desarrollado en Python
y es uno de las herramientas más usadas para este propósito, otras alternativas son Puppet, Chef o Salt.

### ¿En que se diferencia con Terraform?

Mientras Terraform se especializa en el despliegue de recursos de infraestructura, Ansible se enfoca en la gestión de configuración de los sistemas.

### Crear ambiente de prueba

```bash
make start
```

### Probar ambiente

```bash
ansible -i inventory.ini demo -m ping
```

Si todo esta bien configurado debería aparecer un mensaje como este:

```bash
demo | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.12"
    },
    "changed": false,
    "ping": "pong"
}
```

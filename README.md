# Curso - Ansible primeros pasos

Este es el source code del curso primeros que podras ver en mi canal de [youtube](https://www.youtube.com/@DaveOps).

## Requisitos

- Python3 >= 3.8.0
- Multipass (https://multipass.run/install)
- pipx (https://pipx.pypa.io/stable/)

##

Lo primero sera clonar este proyecto

```bash
git clone https://github.com/davefranco/ansibleintro.git
```

## Instrucciones uso

### Instalación

```bash
pipx install --include-deps ansible
```

### Instalar pre-requisitos

```bash
make requirements
```

### Crear ambiente de prueba

```bash
make start
```

### Destruir ambiente de prueba

```bash
make stop
```

## Capitulos

- [1. Introducción](./capitulos/1-intro.md)
- [2. Playbooks](./capitulos/2-playbooks.md)
- [3. Variables](./capitulos/3-variables.md)
- [4. Inventory](./capitulos/4-inventory.md)
- [5. Ansible config](./capitulos/5-ansible-cfg.md)
- [6. Wordpress playbook](./capitulos/6-wordpress-playbook.md)
- [7. Wordpress roles](./capitulos/7-wordpress-roles.md)

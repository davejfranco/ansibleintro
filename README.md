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

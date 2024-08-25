## Archivo de inventarios

En ansible el archivo de inventarios es el archivo que define la configuración de los hosts. vienen en dos formatos:

### ini 
```bash
[lab]
192.168.64.51

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=.ssh/id_rsa
```

### yaml
```yaml
lab:
  hosts:
    192.168.64.51
demo:
  children:
    lab:
all:
  vars:
    ansible_user: ubuntu
    ansible_ssh_private_key_file: .ssh/id_rsa
```
Ambos formatos son compatibles, sin embargo, el formato yaml es el mas moderno. 

En la seccion vars, podemos definir las variables que queremos utilizar en el playbook.

### Inventarios dinamicos

Permite que los servidores sean asociados de forma dinamica, cuando la infraestructura cambia constantemente. Un Ejemplo de ellos es por ejemplo cuando tenemos que configurar servidores sobre EC2 en aws. La forma en que podemos generar esto es mediante scripts en Python o plugins.

ejemplo:
```bash
plugin: amazon.aws.aws_ec2
regions:
- us-east-1
filters:
  tag:Name:
  - 'instance-*'
hostnames:
- tag:Name
```


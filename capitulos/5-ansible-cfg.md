## Archivo de configuración de Ansible

Hay algunos aspectos de ansible que se puede configurar en el archivo de configuración de ansible. Este archivo es `ansible.cfg` por defecto se encuentra en `/etc/ansible`

Para generar un archivo de configuración de ansible, se puede ejecutar el siguiente comando:

```bash
ansible-config init --disabled > ansible.cfg
```

Estos son las opciones que me gustan tener bajo el archivo de configuración de ansible:

```bash
[defaults]
roles_path = roles/
interpreter_python = auto
forks = 20
timeout = 300
pipelining = True
poll_interval = 1
transport = smart
gathering = smart
inject_facts_as_vars = False
host_key_checking = False
stdout_callback = yaml
error_on_missing_handler = True
private_role_vars = True
vault_password_file = vault_password
vault_id_match = True
vault_identity_list = prod@vault_password
ansible_managed = Ansible managed
display_skipped_hosts = False
fact_caching = jsonfile
fact_caching_connection=~/.ansible/facts/
retry_files_enabled = False
force_handlers = True
filter_plugins = ~/.ansible/plugins/filter:/usr/share/ansible/plugins/filter:.

[privilege_escalation]
become = True

[sudo_become_plugin]
flags = -E -H -S -n

[ssh_connection]
ssh_args = -C -o ControlMaster=auto -o ControlPersist=60s -o ForwardAgent=yes
control_path_dir = ~/.ansible/cp

[diff]
always = True
context = 3
```

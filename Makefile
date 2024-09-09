requirements:
	@ansible-galaxy install -r requirements.yaml

start:
	@ansible-playbook vms.yaml -t "start"

stop:
	@ansible-playbook vms.yaml -t "stop"


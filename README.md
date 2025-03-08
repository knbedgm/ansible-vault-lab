# ansible-vault-lab

## Setup

Run `setup.sh` to create a python venv and install ansible and passlib from `requirements.txt'.

Use `ansible-vault rekey` to change the encryption keys used on `dev_vault.yaml` and `prod_vault.yaml` from the example keys in the repo.

## Usage

Since Ansible loads `group_vars/` variables relative to the location of the inventory file different environments had to be split into their own inventories as Ansible bails if any vault file could not be decrypted.

### configure_service

Creates two configuration files in `~/service/` for the api key and the database user and password.

```console
(.venv) kbnt@minidell:~/ansible-vault-lab$ cat ~/service/*
(.venv) kbnt@minidell:~/ansible-vault-lab$ ansible-playbook playbooks/configure_service.yaml -i inventory/dev --vault-id dev@dev.passfile

PLAY [Configure Service] *******************************************************

TASK [Create API Config] *******************************************************
[WARNING]: Platform linux on host local is using the discovered Python interpreter at /home/kbnt/ansible-vault-lab/.venv/bin/python3.12, but future installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.18/reference_appendices/interpreter_discovery.html for more information.
ok: [local]

TASK [Create DB Config] ********************************************************
ok: [local]

PLAY RECAP *********************************************************************
local                      : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

(.venv) kbnt@minidell:~/ansible-vault-lab$ cat ~/service/*
API_KEY=api_key_123456_dev
DB_USER=db_admin_dev
DB_PASS=db_pass_123_dev
```

### create_user

Creates a user account on the system with username `service_runner`.

```console
(.venv) root@minidell:/home/kbnt/ansible-vault-lab# tail /etc/passwd -n 3
libvirt-qemu:x:64055:993:Libvirt Qemu,,,:/var/lib/libvirt:/usr/sbin/nologin
libvirt-dnsmasq:x:123:127:Libvirt Dnsmasq,,,:/var/lib/libvirt/dnsmasq:/usr/sbin/nologin
sshd:x:124:65534::/run/sshd:/usr/sbin/nologin
(.venv) root@minidell:/home/kbnt/ansible-vault-lab# ansible-playbook playbooks/create_user.yaml -i inventory/prod --vault-id prod@prod.passfile

PLAY [Create User] *************************************************************
TASK [Create User] *************************************************************
[WARNING]: Platform linux on host local is using the discovered Python interpreter at /home/kbnt/ansible-vault-lab/.venv/bin/python3.12, but future installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.18/reference_appendices/interpreter_discovery.html for more information.
changed: [local]

PLAY RECAP *********************************************************************
local                      : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

(.venv) root@minidell:/home/kbnt/ansible-vault-lab# tail /etc/passwd -n 3
libvirt-dnsmasq:x:123:127:Libvirt Dnsmasq,,,:/var/lib/libvirt/dnsmasq:/usr/sbin/nologin
sshd:x:124:65534::/run/sshd:/usr/sbin/nologin
service_runner:x:1001:1001::/home/service_runner:/bin/sh
```

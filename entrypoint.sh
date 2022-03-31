#!/usr/bin/env bash
ansible --version

ansible-playbook playbooks/secure-config.yml -vvv
ansible-playbook playbooks/docker-install.yml -vvv

sleep 1d
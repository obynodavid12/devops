#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# install Python3-pip and Ansible
sudo apt update -y
sudo aptitude -f install
sudo apt install -y ansible

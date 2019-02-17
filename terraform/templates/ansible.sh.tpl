#!/bin/bash

sudo sed -i 's/us-east-1.ec2.//g' /etc/apt/sources.list
sudo apt-get -qq update
sudo apt-get install -yqq ansible
sudo chmod 400 /home/ubuntu/.ssh/aws_ec2.pem
sudo sed -i '11ihost_key_checking = False' /etc/ansible/ansible.cfg
sudo sed -i '12istdout_callback = debug' /etc/ansible/ansible.cfg
sudo sed -i '13inventory = /home/ubuntu/inventory' /etc/ansible/ansible.cfg
cd /tmp
git clone https://github.com/sharonnavon/project.git

cat << EOF | sudo tee /home/ubuntu/inventory
prometheus ansible_host=${prometheus_priv_ip}

EOF

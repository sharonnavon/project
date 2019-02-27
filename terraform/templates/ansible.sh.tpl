#!/bin/bash

sudo sed -i 's/us-east-1.ec2.//g' /etc/apt/sources.list
sudo apt-get -qq update
sudo apt-get install -yqq software-properties-common python-pip
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install -yqq ansible
sudo pip install boto
sudo chmod 400 /home/ubuntu/.ssh/aws_ec2.pem
sudo sed -i '11ihost_key_checking = False' /etc/ansible/ansible.cfg
sudo wget -O /etc/ansible/hosts https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py
sudo chmod +x /etc/ansible/hosts
sudo wget -O /etc/ansible/ec2.ini https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.ini
sudo sed -i 's/regions = all/regions = us-east-1/g' /etc/ansible/ec2.ini
sudo sed -i 's/vpc_destination_variable = ip_address/vpc_destination_variable = private_ip_address/g' /etc/ansible/ec2.ini

cd /opt
sudo git clone https://github.com/sharonnavon/project.git

#sudo ansible-playbook /opt/project/ansible/site.yml

#!/usr/bin/env bash

# Install Docker-ce
sudo sed -i 's/us-east-1.ec2.//g' /etc/apt/sources.list
sudo apt -qq update
sudo apt install -yqq apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt -qq update
sudo apt install -yqq docker-ce


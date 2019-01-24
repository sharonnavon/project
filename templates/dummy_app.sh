#!/usr/bin/env bash

# Install Docker-ce
sudo sed -i 's/us-east-1.ec2.//g' /etc/apt/sources.list
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt -qq update &> /dev/null
sudo apt install -yqq apt-transport-https ca-certificates curl gnupg2 software-properties-common docker-ce &> /dev/null

# Build & run the dummy container
sudo mkdir /opt/docker
cd /opt/docker
sudo wget https://raw.githubusercontent.com/sharonnavon/project/master/templates/Dockerfile
sudo wget -O /opt/docker/my_dummy_exporter.py https://raw.githubusercontent.com/sharonnavon/project/master/templates/my_dummy_exporter.py
sudo docker build -t dummyapp .
sudo docker run --name=dummyapp -v /opt/docker/my_dummy_exporter.py:/tmp/my_dummy_exporter.py -d -p 65433:65433 dummyapp

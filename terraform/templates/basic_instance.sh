#!/bin/bash

sudo sed -i 's/us-east-1.ec2.//g' /etc/apt/sources.list
sudo apt-get -qq update
sudo apt-get install -yqq python

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
sudo wget https://raw.githubusercontent.com/sharonnavon/project/master/terraform/templates/Dockerfile
sudo wget -O /opt/docker/my_dummy_exporter.py https://raw.githubusercontent.com/sharonnavon/project/master/terraform/templates/my_dummy_exporter.py
sudo docker build -t dummyapp .
sudo docker run --name=dummyapp -v /opt/docker/my_dummy_exporter.py:/tmp/my_dummy_exporter.py -d -p 65433:65433 dummyapp


# Register the dummy app in consul
cat << EOF | sudo tee /etc/consul.d/dummy-app.json
{
  "service": {
    "name": "dummy-app",
    "id": "dummy-app",
    "port": 65433,
    "check": {
      "name": "dummy_app port 65433 http check",
      "interval": "5s",
      "http": "http://localhost:65433"
    }
  }
}

EOF

sudo systemctl reload consul


# Build & run the filebeat container
cat << EOF | sudo tee /opt/docker/filebeat.yml
filebeat.config:
  prospectors:
    path: /usr/share/filebeat/prospectors.d/*.yml
    reload.enabled: false
  modules:
    path: /usr/share/filebeat/modules.d/*.yml
    reload.enabled: false

filebeat.autodiscover:
  providers:
    - type: docker
      hints.enabled: true

processors:
- add_cloud_metadata: ~

output.logstash:
  hosts: ["${elk_priv_ip}:5044"]

setup.kibana:
  host: "${elk_priv_ip}:5601"

EOF


sudo docker run -d \
  --name=filebeat \
  --user=root \
  -v /opt/docker/filebeat.yml:/usr/share/filebeat/filebeat.yml \
  -v /var/lib/docker/containers:/var/lib/docker/containers:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  docker.elastic.co/beats/filebeat:6.5.4 filebeat -e -strict.perms=false

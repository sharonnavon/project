#!/bin/bash

# Install ElasticSearch
sudo sed -i 's/us-east-1.ec2.//g' /etc/apt/sources.list
sudo apt -qq update
#sudo apt install -y grafana
#sudo systemctl enable grafana-server.service


# Register ElasticSearch in consul
cat << EOF | sudo tee  /etc/consul.d/elasticsearch-9200.json
{
  "service": {
    "name": "elasticsearch-9200",
    "id": "elasticsearch-9200",
    "port": 9200,
    "check": {
      "name": "Port 9200 http check",
      "interval": "5s",
      "http": "http://localhost:9200"
    }
  }
}

EOF

sudo systemctl reload consul

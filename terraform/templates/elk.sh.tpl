#!/bin/bash

# Install ElasticSearch
sudo sed -i 's/us-east-1.ec2.//g' /etc/apt/sources.list
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get -qq update
sudo apt-get install -yqq openjdk-8-jre-headless openjdk-8-jdk-headless
sudo apt-get install -yqq elasticsearch logstash kibana
sudo systemctl enable elasticsearch logstash kibana
sudo systemctl start elasticsearch logstash kibana


# Register in consul
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

cat << EOF | sudo tee  /etc/consul.d/kibana-5601.json
{
  "service": {
    "name": "kibana-5601",
    "id": "kibana-5601",
    "port": 5601,
    "check": {
      "name": "Port 5601 http check",
      "interval": "5s",
      "http": "http://localhost:5601"
    }
  }
}

EOF

sudo systemctl reload consul

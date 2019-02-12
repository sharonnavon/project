#!/bin/bash

# Install ELK
sudo sed -i 's/us-east-1.ec2.//g' /etc/apt/sources.list
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get -qq update
sudo apt-get install -y openjdk-8-jre-headless openjdk-8-jdk-headless
sudo apt-get install -y elasticsearch logstash kibana
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch logstash kibana
sudo systemctl start elasticsearch logstash kibana


# Configure Elasticsearch
cat << EOF | sudo tee --append /etc/elasticsearch/elasticsearch.yml

network.host: 0.0.0.0
http.port: 9200

EOF


# Configure LogStash
cat << EOF | sudo tee /etc/logstash/conf.d/demo-metrics-pipeline.conf
input {
  beats {
    port => 5044
  }
}

# The filter part of this file is commented out to indicate that it
# is optional.
# filter {
#
# }

output {
  elasticsearch {
    hosts => "localhost:9200"
    manage_template => false
    index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
  }
}

EOF


# Configure Kibana
cat << EOF | sudo tee --append /etc/kibana/kibana.yml

server.name: kibana
server.host: "0.0.0.0"
elasticsearch.url: "http://localhost:9200"

EOF

sudo systemctl restart kibana


# Register in consul
cat << EOF | sudo tee /etc/consul.d/elasticsearch.json
{
  "service": {
    "name": "elasticsearch",
    "id": "elasticsearch",
    "port": 9200,
    "check": {
      "name": "elasticsearch port 9200 http check",
      "interval": "5s",
      "http": "http://localhost:9200/_cluster/health?pretty=true"
    }
  }
}

EOF

cat << EOF | sudo tee /etc/consul.d/logstash.json
{
  "service": {
    "name": "logstash",
    "id": "logstash",
    "port": 5044,
    "check": {
      "name": "logstash port 5044 tcp check",
      "interval": "5s",
      "TCP": "localhost:5044"
    }
  }
}

EOF

cat << EOF | sudo tee /etc/consul.d/kibana.json
{
  "service": {
    "name": "kibana",
    "id": "kibana",
    "port": 5601,
    "check": {
      "name": "kibana port 5601 http check",
      "interval": "5s",
      "http": "http://localhost:5601"
    }
  }
}

EOF

sudo systemctl reload consul

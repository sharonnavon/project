#!/bin/bash

sudo sed -i 's/us-east-1.ec2.//g' /etc/apt/sources.list
sudo apt -qq update
sudo apt-get install -y prometheus
cat << EOF | sudo tee --append /etc/prometheus/prometheus.yml

  - job_name: 'consul'
    scrape_interval: 5s
    consul_sd_configs:
      - datacenter: opsschool
        server: 'localhost:8500'

EOF
sudo systemctl restart prometheus

# Register Prometheus in consul
cat << EOF | sudo tee  /etc/consul.d/prometheus.json
{
  "service": {
    "name": "prometheus",
    "id": "prometheus",
    "port": 9090,
    "check": {
      "name": "prometheus port 9090 http check",
      "interval": "5s",
      "http": "http://localhost:9090"
    }
  }
}

EOF

sudo systemctl reload consul

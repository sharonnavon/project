#!/bin/bash

sudo sed -i 's/us-east-1.ec2.//g' /etc/apt/sources.list
sudo apt -qq update
sudo apt-get install -y prometheus
cat << EOF | sudo tee --append /etc/prometheus/prometheus.yml

#  - job_name: 'my_dummy_exporter'
#    scrape_interval: 5s
#    metrics_path: ''
#    static_configs:
#      - targets: ['node-exporter1:65433', 'node-exporter2:65433']

  - job_name: 'consul'
    scrape_interval: 5s
    consul_sd_configs:
      - datacenter: opsschool
        server: 'localhost:8500'

EOF
sudo systemctl restart prometheus

# Register Prometheus in consul
cat << EOF | sudo tee  /etc/consul.d/prometheus-9090.json
{
  "service": {
    "name": "prometheus-9090",
    "id": "prometheus-9090",
    "port": 9090,
    "check": {
      "name": "Port 9090 http check",
      "interval": "5s",
      "http": "http://localhost:9090"
    }
  }
}

EOF

sudo systemctl reload consul

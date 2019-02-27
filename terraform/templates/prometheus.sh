#!/bin/bash

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

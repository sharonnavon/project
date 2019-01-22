#!/bin/bash

sudo sed -i 's/us-east-1.ec2.//g' /etc/apt/sources.list
sudo apt -qq update
sudo apt-get install -y python

# Run node exporter app
git clone https://github.com/ops-school/session-monitoring.git
nohup python /home/ubuntu/session-monitoring/training_session/my_dummy_exporter.py &

# Register the app in consul
cat > /etc/consul.d/python-65433.json << EOF
{
  "service": {
    "name": "python-65433",
    "id":"python-65433",
    "port": 65433,
    "check": {
      "name": "Port 65433 tcp check",
      "interval": "30s",
      "TCP": "localhost:65433"
    }
  }
}

EOF

sudo systemctl reload consul

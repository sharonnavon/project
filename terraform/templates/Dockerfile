FROM 1and1internet/ubuntu-16
RUN apt-get -qq update
RUN apt-get install -yqq python curl
RUN curl -sLo /tmp/consul.sh https://raw.githubusercontent.com/sharonnavon/project/master/terraform/templates/consul.sh.tpl
RUN export "consul_version=1.4.0"
RUN config = <<EOF
     "node_name": "dummy-app1-cont",
     "enable_script_checks": true,
     "server": false
    EOF
WORKDIR /tmp
CMD python my_dummy_exporter.py
CMD chmod 700 consul.sh
CMD /bin/bash ./consul.sh

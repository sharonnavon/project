FROM 1and1internet/ubuntu-16
RUN apt-get -qq update
RUN apt-get install -yqq python
WORKDIR /tmp
CMD chmod 755 consul_dummy1.sh
CMD python my_dummy_exporter.py
CMD chmod 700 consul.sh
CMD /bin/bash ./consul.sh

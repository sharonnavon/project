FROM ubuntu
RUN apt-get -qq update
RUN apt-get install -yqq git python
RUN mkdir /opt/dummy_app
#RUN git clone https://github.com/ops-school/session-monitoring /opt/dummy_app/
RUN cd /opt/dummy_app
RUN wget https://raw.githubusercontent.com/sharonnavon/project/master/templates/my_dummy_exporter.py
#WORKDIR /opt/dummy_app/training_session/
WORKDIR /opt/dummy_app
CMD ["python", "my_dummy_exporter.py"]

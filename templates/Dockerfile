FROM ubuntu
RUN apt-get -qq update
RUN apt-get install -yqq git python
RUN mkdir /opt/dummy_app
RUN git clone https://github.com/ops-school/session-monitoring /opt/dummy_app/
WORKDIR /opt/dummy_app/training_session/
CMD ["python", "my_dummy_exporter.py"]

FROM python:3.8

RUN apt update && apt install mc net-tools iputils-ping -y
RUN pip3 install mysql-connector prometheus_client httpserver
ARG SRC_DIR=/usr/bin/src/webapp/src
COPY simple_server.py ${SRC_DIR}/
WORKDIR ${SRC_DIR}

ENV PYTHONUNBUFFERED=1

CMD ["python3", "simple_server.py"]

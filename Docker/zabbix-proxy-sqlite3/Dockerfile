# syntax=docker/dockerfile:1
ARG MAJOR_VERSION=6.2
ARG ZBX_VERSION=${MAJOR_VERSION}.0
ARG BUILD_BASE_IMAGE=zabbix-proxy-sqlite3:alpine-${ZBX_VERSION}

FROM zabbix/${BUILD_BASE_IMAGE}

USER root

RUN sed -i 's/https/http/' /etc/apk/repositories
COPY ./requirements.txt /

RUN apk update && apk add --no-cache --clean-protected gcc libc-dev python3 python3-dev py3-pip net-snmp net-snmp-dev
RUN pip config set global.trusted-host "pypi.org files.pythonhosted.org pypi.python.org" && pip3 install --no-cache-dir --upgrade pip && \
    pip install -r /requirements.txt && \
    rm -rf /var/cache/apk/*

#COPY ./python-packages /usr/lib/python3.9/site-packages

USER 1997


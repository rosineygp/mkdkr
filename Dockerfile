# this dockerfile is an example
FROM python:3.6-alpine

RUN pip install jinja2-cli[yaml] && \
  apk add bash

COPY generator /generator

WORKDIR /generator

RUN ln -sf /generator/gitlab-ci /usr/local/bin/
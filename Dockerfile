FROM alpine:3

ENV DOCKER_BIN="https://download.docker.com/linux/static/stable/x86_64/docker-19.03.5.tgz"

RUN apk add --no-cache \
  curl \
  git \
  make \
  bash

RUN curl "${DOCKER_BIN}" > /tmp/docker.tgz \
	&& tar -zxvf /tmp/docker.tgz --strip=1 -C /usr/local/bin/
FROM docker:19

RUN apk add --no-cache \
  curl \
  git \
  make \
  bash

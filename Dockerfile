FROM docker:19

# hadolint ignore=DL3018
RUN apk add --no-cache \
  curl \
  git \
  make \
  bash

#!/usr/bin/env bash

set -e

make -j3 --output-sync=line \
  lint.commit \
  lint.shellcheck \
  lint.hadolint

make test.unit
    
make -j6 --output-sync=line \
  bash.v5-0 \
  bash.v4-4 \
  bash.v4-3 \
  bash.v4-2 \
  bash.v4-1 \
  bash.v4-0

make -j8 --output-sync=line \
  examples.simple \
  examples.service \
  examples.dind \
  examples.escapes \
  examples.stdout \
  examples.shell \
  examples.retry \
  examples.pipeline


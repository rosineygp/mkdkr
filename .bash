#!/bin/bash

set -x

launch() {
  docker run --rm -d \
    --name "${name:-make_test}" \
    --entrypoint "" \
    -v $(pwd):/repos \
    --workdir /repos \
    ${1:-alpine} \
    sleep ${ttl:-3600}
}

.=() {
  docker exec -i ${name:-make_test} sh -c "$*"
}

destroy(){
  docker rm -f ${name:-make_test}
}
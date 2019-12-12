#!/bin/bash

launch() {
  destroy || true
  image="${1:-alpine}"
  args="${2}"
  # shellcheck disable=SC2086
  docker run --rm -d \
    --name "${name:-unnamed}" \
    --entrypoint "" \
    -v "$(pwd)":"$(pwd)" \
    --workdir "$(pwd)" \
    ${args} \
    "${image}" \
    sleep "${ttl:-3600}"
}

service() {
  destroy "${name:-unnamed_service}" || true
  image="${1:-nginx}"
  args="${2}"
  # shellcheck disable=SC2086
  docker run -d \
    --name "${name:-unnamed_service}" \
    -v "$(pwd)":/repos \
    --workdir /repos \
    ${args} \
    "${image}"
  SERVICE_ID=$(docker ps --filter "name=${name:-unnamed_service}" --format "{{.ID}}")
  # shellcheck disable=SC2015
  sleep "${ttl:-3600}" && docker rm -f "${SERVICE_ID}" || true &
}

privileged() {
  image="${1:-alpine}"
  args="${2}"
  launch "$image" "--privileged -v /var/run/docker.sock:/var/run/docker.sock ${args}"
}

# shellcheck disable=SC1036
.=() {
  docker exec -i ${name:-unnamed} sh -c "$*"
}

destroy(){
  docker rm -f "${1:-${name:-unnamed}}"
}
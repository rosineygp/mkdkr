.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define .
	source .mkdkr
	JOB_NAME="$(@)_$(shell date +%Y%m%d%H%M%S)"
endef

# END OF MAKE DEFINITIONS, CREATE YOUR JOBS BELOW

.PHONY: small shellcheck service dind brainfuck scenarios

scenarios: small service dind

small:
	$(call .)
	... job alpine --cpus 1 --memory 32MB
	.. echo "Hello darkness, my old friend"
	.

shellcheck:
	$(call .)
	... job ubuntu:18.04
	.. apt-get update '&&' \
		apt-get install -y shellcheck
	.. shellcheck -e SC1088 -e SC2068 -e SC2086 .mkdkr
	.

service:
	$(call .)
	... service nginx
	... job alpine --link service_$$JOB_NAME:nginx
	.. apk add curl
	.. curl -s nginx
	.

dind:
	$(call .)
	... privileged docker:19
	.. docker build --force-rm --no-cache -t mdp:dind .
	.

brainfuck:
	$(call .)
	... privileged docker:19
	.. apk add make bash
	.. make pipeline
	.

pipeline:
	make shellcheck
	make scenarios -j3
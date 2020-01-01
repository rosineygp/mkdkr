.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval JOB_NAME=$(shell bash -c 'source .mkdkr; .... $(@)'))
endef

# END OF MAKE DEFINITIONS, CREATE YOUR JOBS BELOW

.PHONY: small shellcheck service dind brainfuck scenarios

scenarios: small service dind

small:
	@$(.)
	... job alpine --cpus 1 --memory 32MB
	.. echo "Hello darkness, my old friend"
	.. echo "hello world!"
	.. ps -ef
	.

shellcheck:
	@$(.)
	... job koalaman/shellcheck-alpine:v0.4.6
	.. shellcheck -e SC1088 -e SC2068 -e SC2086 .mkdkr
	.. shellcheck generator/gitlab-ci
	.. shellcheck -e SC2181 test/unit_job_name
	.

unit:
	@$(.)
	... privileged docker:19 --workdir $(PWD)/test
	.. apk add bash
	.. ./unit_job_name
	.

service:
	@$(.)
	... service nginx
	... job alpine --link service_$$JOB_NAME:nginx
	.. apk add curl
	.. curl -s nginx
	.

dind:
	@$(.)
	... privileged docker:19
	.. docker build -t rosiney/mkdkr .
	.

brainfuck:
	@$(.)
	... privileged docker:19
	.. apk add make bash
	.. make pipeline
	.

generator/gitlab:
	@$(.)
	... job rosineygp/mkdkr
	.. gitlab-ci lint=shellcheck \
		scenarios=small,service,dind > .gitlab-ci.yml
	.

pipeline:
	make shellcheck
	make unit
	make scenarios -j3
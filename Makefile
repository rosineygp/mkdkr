.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval JOB_NAME=$(shell bash -c 'source .mkdkr; .... $(@)'))
endef

# END OF MAKE DEFINITIONS, CREATE YOUR JOBS BELOW

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

coverage:
	@$(.)
	... job kcov/kcov:v31 \
		-e CODECOV_TOKEN=$$CODECOV_TOKEN \
		--workdir $(PWD)/test
	.. 'apt-get update && \
		apt-get install -y git curl'
	.. kcov --exclude-path=shunit2 coverage unit_job_name
	.. kcov --exclude-path=shunit2 coverage .mkdkr
	.. 'curl -s https://codecov.io/bash | bash -s --'
	.

simple:
	make --silent -f examples/simple.mk simple

service:
	make --silent -f examples/service.mk service

dind:
	make --silent -f examples/dind.mk dind

escapes:
	make --silent -f examples/escapes.mk all

examples/pipeline:
	@cd examples && make --silent -f pipeline.mk pipeline

scenarios: simple service dind escapes example/pipeline

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
	make --silent shellcheck
	make --silent unit
	make --silent scenarios -j $(shell nproc) --output-sync
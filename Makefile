.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval MKDKR_JOB_NAME=$(shell source .mkdkr; .... $(@)))
	trap '.' EXIT
endef

# END OF MAKE DEFINITIONS, CREATE YOUR JOBS BELOW

commitlint:
	@$(.)
	... node:10
	.. npm install -g @commitlint/cli @commitlint/config-conventional
	.. commitlint --from=HEAD~1 --verbose

shellcheck:
	@$(.)
	... koalaman/shellcheck-alpine:v0.4.6
	.. shellcheck -e SC1088 -e SC2068 -e SC2086 .mkdkr
	.. shellcheck generator/gitlab-ci
	.. shellcheck -e SC2181 test/unit_job_name

unit:
	@$(.)
	... privileged docker:19 --workdir $(PWD)/test
	.. apk add bash
	.. ./unit_job_name

coverage:
	@$(.)
	... kcov/kcov:v31 --workdir $(PWD)/test
	.. rm -rf coverage
	.. kcov --exclude-path=shunit2 coverage unit_job_name
	... python:3.6-buster --workdir $(PWD)/test/coverage
	.. pip install anybadge
	.. anybadge \
		--value=$$(cat test/coverage/index.json | sed -n 's|.*"covered":"\([^"]*\)".*|\1|p') \
		--file=coverage.svg coverage
	... node:12 \
		-e SURGE_LOGIN='$(SURGE_LOGIN)' \
		-e SURGE_TOKEN=$$SURGE_TOKEN
	.. cp .surgeignore ./test/coverage/
	.. npm install -g surge
	.. surge --project ./test/coverage --domain mkdkr.surge.sh

simple:
	make --silent -f examples/simple.mk simple

multi-images:
	make --silent -f examples/simple.mk multi-images

service:
	make --silent -f examples/service.mk service

dind:
	make --silent -f examples/dind.mk dind

escapes:
	make --silent -f examples/escapes.mk all

shell:
	make --silent -f examples/shell.mk shell

trap:
	make --silent -f examples/trap.mk

implicit-job:
	make --silent -f examples/implicit-job.mk

examples/pipeline:
	@cd examples && make --silent -f pipeline.mk pipeline

scenarios: simple multi-images service dind escapes shell trap implicit-job examples/pipeline

brainfuck:
	@$(.)
	... privileged docker:19
	.. apk add make bash
	.. make pipeline

generator/gitlab:
	@$(.)
	... rosineygp/mkdkr
	.. gitlab-ci lint=shellcheck \
		scenarios=small,service,dind > .gitlab-ci.yml

pipeline:
	make --silent commitlint
	make --silent shellcheck
	make --silent unit
	make --silent scenarios -j $(shell nproc) --output-sync
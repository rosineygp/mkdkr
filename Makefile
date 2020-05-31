include $(shell bash .mkdkr init)

lint.commit:
	@$(dkr)
	instance: rosiney/mkdkr_commitlint
	@if [ ! -f commitlint.config.js ]; then \
		echo "module.exports = {extends: ['@commitlint/config-conventional']}" > commitlint.config.js; \
	fi
	run: commitlint --from=HEAD~1 --verbose

lint.shellcheck:
	@$(dkr)
	instance: koalaman/shellcheck-alpine:v0.7.1
	run: shellcheck .mkdkr
	instance: koalaman/shellcheck-alpine:v0.4.6
	run: shellcheck -e SC2181 test/unit_job_name
	run: shellcheck -e SC2181 -e SC2086 test/unit_create_instance
	run: shellcheck -e SC2181 -e SC2086 -e SC1091 test/unit_branch_or_tag_name
	run: shellcheck -e SC2181 -e SC2086 -e SC1091 test/unit_branch_or_tag_name_slug
	run: shellcheck -e SC2181 -e SC2086 -e SC1091 test/unit_remote_include
	run: shellcheck -e SC2181 -e SC2086 -e SC1091 test/unit_requirements
	run: shellcheck test/cover

lint.hadolint:
	@$(dkr)
	instance: hadolint/hadolint:latest-alpine
	run: hadolint Dockerfile

test.unit:
	@$(dkr)
	dind: docker:19 --workdir $(PWD)/test
	run: apk add bash jq git make
	run: ./unit

DOCKER_BIN=https://download.docker.com/linux/static/stable/x86_64/docker-19.03.5.tgz

define _docker_cli =
	run: curl -s '$(DOCKER_BIN) > /tmp/docker.tgz'
	run: tar -zxvf /tmp/docker.tgz --strip=1 -C /usr/local/bin/
endef

define _bash_reqs =
	$(dkr)
	dind: $(1)
	run: apk add curl git make
	$(call _docker_cli)
	run: make test.unit
endef

bash.v5-0:
	$(call _bash_reqs, bash:5.0)

bash.v4-4:
	$(call _bash_reqs, bash:4.4)

bash.v4-3:
	$(call _bash_reqs, bash:4.3)

bash.v4-2:
	$(call _bash_reqs, bash:4.2)

bash.v4-1:
	$(call _bash_reqs, bash:4.1)

bash.v4-0:
	$(call _bash_reqs, bash:4.0)

_coverage.report:
	@$(dkr)
	dind: kcov/kcov:v31 --workdir $(PWD)/test
	run: rm -rf coverage
	run: 'apt-get update && apt-get install -y curl jq bc git make'
	$(call _docker_cli)
	run: kcov --include-path=.mkdkr coverage unit
	run: './cover > coverage/coverage.json'
	instance: node:12 \
		-e SURGE_LOGIN='$(SURGE_LOGIN)' \
		-e SURGE_TOKEN=$$SURGE_TOKEN
	run: cp .surgeignore ./test/coverage/
	run: npm install -g surge
	run: surge --project ./test/coverage --domain mkdkr.surge.sh

examples.simple:
	make --silent -f examples/simple.mk simple
	make --silent -f examples/simple.mk multi-images

examples.service:
	make --silent -f examples/service.mk link
	make --silent -f examples/service.mk service
	make --silent -f examples/service.mk multiply

examples.dind:
	make --silent -f examples/dind.mk dind

examples.escapes:
	make --silent -f examples/escapes.mk multiline
	make --silent -f examples/escapes.mk logical_and
	make --silent -f examples/escapes.mk pipes
	make --silent -f examples/escapes.mk redirect_to_outside

examples.stdout:
	make --silent -f examples/stdout.mk parse-output
	make --silent -f examples/stdout.mk from
	make --silent -f examples/stdout.mk back-to-container

examples.shell:
	make --silent -f examples/shell.mk shell

examples.retry:
	make --silent -f examples/retry.mk slow-service

examples.pipeline:
	make -f examples/pipeline.mk test -j 3 --output-sync
	make -f examples/pipeline.mk build
	make -f examples/pipeline.mk pack
	make -f examples/pipeline.mk deploy

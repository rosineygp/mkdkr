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
	instance: koalaman/shellcheck-alpine:v0.4.6
	run: shellcheck -e SC2068 -e SC2086 .mkdkr
	run: shellcheck -e SC2181 test/unit_job_name
	run: shellcheck -e SC2181 -e SC2086 test/unit_create_instance
	run: shellcheck -e SC2181 -e SC2086 -e SC1091 test/unit_branch_or_tag_name
	run: shellcheck -e SC2181 -e SC2086 -e SC1091 test/unit_branch_or_tag_name_slug
	run: shellcheck -e SC2181 -e SC2086 -e SC1091 test/unit_remote_include
	run: shellcheck test/cover

examples.simple:
	make --silent -f examples/simple.mk simple
	make --silent -f examples/simple.mk multi-images

examples.service:
	make --silent -f examples/service.mk service
	make --silent -f examples/service.mk link

examples.dind:
	make --silent -f examples/dind.mk dind

examples.escapes:
	make --silent -f examples/escapes.mk multiline
	make --silent -f examples/escapes.mk logical_and
	make --silent -f examples/escapes.mk pipes
	make --silent -f examples/escapes.mk redirect_to_outside

examples.stdout:
	make --silent -f examples/stdout.mk from-filename
	make --silent -f examples/stdout.mk from-function
	make --silent -f examples/stdout.mk show-path
	make --silent -f examples/stdout.mk parse-output
	make --silent -f examples/stdout.mk from

examples.shell:
	make --silent -f examples/shell.mk shell

examples.pipeline:
	make -f examples/pipeline.mk test -j 3 --output-sync
	make -f examples/pipeline.mk build
	make -f examples/pipeline.mk pack
	make -f examples/pipeline.mk deploy
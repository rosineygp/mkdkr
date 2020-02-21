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
	run: shellcheck -e SC1088 -e SC2068 -e SC2086 .mkdkr \|\| true
	run: shellcheck -e SC2181 test/unit_job_name
	run: shellcheck -e SC2181 -e SC2086 test/unit_create_instance
	run: shellcheck -e SC2181 -e SC2086 -e SC1091 test/unit_branch_or_tag_name
	run: shellcheck -e SC2181 -e SC2086 -e SC1091 test/unit_branch_or_tag_name_slug
	run: shellcheck -e SC2181 -e SC2086 -e SC1091 test/unit_remote_include
	run: shellcheck test/cover

test.service:
	@$(dkr)
	service: nginx
	instance: alpine --link service_$$MKDKR_JOB_NAME:nginx
	run: apk add curl
	run: curl -s nginx

test.dind:
	@$(dkr)
	dind: docker:19
	run: docker build -t rosiney/pylint .

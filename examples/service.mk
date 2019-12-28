.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval JOB_NAME=$(shell bash -c 'source .mkdkr; .... $(@)'))
endef

.PHONY: service

service:
	@$(.)
	... service nginx
	... job alpine --link service_$$JOB_NAME:nginx
	.. apk add curl
	.. curl -s nginx
	.
.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval JOB_NAME=$(shell bash -c 'source .mkdkr; .... $(@)'))
	trap '.' EXIT
endef

service:
	@$(.)
	... service nginx
	... alpine --link service_$$JOB_NAME:nginx
	.. apk add curl
	.. curl -s nginx

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

link:
	@$(.)
	... service nginx
	... alpine
	.. apk add curl
	.. curl -s nginx
	... ubuntu:18.04
	.. apt-get update
	.. apt-get install curl -y
	.. curl -s nginx

.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval JOB_NAME=$(shell bash -c 'source .mkdkr; .... $(@)'))
	trap '_destroy_on_exit' EXIT
endef

implicit-job:
	@$(.)
	... alpine --memory 32MB
	.. echo "hello nano job"
	.

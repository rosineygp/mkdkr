.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval JOB_NAME=$(shell bash -c 'source .mkdkr; .... $(@)'))
endef

.PHONY: simple

simple:
	@$(.)
	... job alpine
	.. echo "hello mkdkr!"
	.

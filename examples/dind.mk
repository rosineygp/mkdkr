.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval JOB_NAME=$(shell bash -c 'source .mkdkr; .... $(@)'))
endef

.PHONY: dind

dind:
	@$(.)
	... privileged docker:19
	.. docker build -t rosiney/pylint .
	.

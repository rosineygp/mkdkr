.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval JOB_NAME=$(shell bash -c 'source .mkdkr; .... $(@)'))
endef

.PHONY: simple

shell:
	@$(.)
	... job ubuntu:18.04
	.. 'apt-get update && apt-get install -y csh tcsh ksh bash'
	.. 'echo $$0'
	export MKDKR_SHELL=csh
	.. 'ps -p $$$$ -ocomm='
	export MKDKR_SHELL=tcsh
	.. 'echo $$0'
	export MKDKR_SHELL=ksh
	.. 'echo $$0'
	export MKDKR_SHELL=bash
	.. 'echo $$0'
	.

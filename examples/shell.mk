include $(shell bash .mkdkr init)

shell:
	@$(.)
	... ubuntu:18.04
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

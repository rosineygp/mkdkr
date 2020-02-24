include $(shell bash .mkdkr init)

shell:
	@$(dkr)
	instance: ubuntu:18.04
	run: 'apt-get update && apt-get install -y csh tcsh ksh bash'
	run: 'echo $$0'
	export MKDKR_SHELL=csh
	run: 'ps -p $$$$ -ocomm='
	export MKDKR_SHELL=tcsh
	run: 'echo $$0'
	export MKDKR_SHELL=ksh
	run: 'echo $$0'
	export MKDKR_SHELL=bash
	run: 'echo $$0'

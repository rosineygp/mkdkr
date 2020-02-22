include $(shell bash .mkdkr init)

from-filename:
	@$(dkr)
	instance: alpine
	run: echo "hello mkdkr!"
	cat "$(MKDKR_JOB_STDOUT)"

from-function:
	@$(dkr)
	instance: alpine
	run: echo "hello mkdkr!"
	$(stdout)
	run: apk add curl
	$(stdout)

show-path:
	@$(dkr)
	instance: alpine
	run: echo "hello mkdkr!"
	echo "$(MKDKR_JOB_STDOUT)"

parse-output:
	@$(dkr)
	instance: debian
	run: apt-get update
	run: apt-get install curl -y
	run: dpkg -l
	$(stdout) | grep -i curl && echo "INSTALLED"

from:
	@$(dkr)
	instance: alpine
	run: echo "passing parameters"
	$(MAKE) -f examples/stdout.mk param PARAM="$$(cat $(MKDKR_JOB_STDOUT))"

param:
	@$(dkr)
	instance: alpine
	run: echo $(PARAM)

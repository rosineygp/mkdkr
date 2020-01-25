include $(shell bash .mkdkr init)

from-filename:
	@$(.)
	... alpine
	.. echo "hello mkdkr!"
	cat "$(MKDKR_JOB_STDOUT)"

from-function:
	@$(.)
	... alpine
	.. echo "hello mkdkr!"
	$(stdout)
	.. apk add curl
	$(stdout)

show-path:
	@$(.)
	... alpine
	.. echo "hello mkdkr!"
	echo "$(MKDKR_JOB_STDOUT)"

parse-output:
	@$(.)
	... debian
	.. apt-get update
	.. apt-get install curl -y
	.. dpkg -l
	$(stdout) | grep -i curl && echo "INSTALLED"

from:
	@$(.)
	... alpine
	.. echo "passing parameters"
	$(MAKE) -f examples/stdout.mk param PARAM="$$(cat $(MKDKR_JOB_STDOUT))"

param:
	@$(.)
	... alpine
	.. echo $(PARAM)

all: from-filename from-function show-path parse-output from
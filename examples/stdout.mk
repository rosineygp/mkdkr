include $(shell bash .mkdkr init)

parse-output:
	@$(dkr)
	instance: debian
	run: apt-get update
	run: ls -la
	run: printenv
	log: 2
	log: 1
	log: 0

from:
	@$(dkr)
	instance: alpine
	run: echo "passing parameters"
	log: 0
	$(MAKE) -f examples/stdout.mk param PARAM="$$(log: 0)"

param:
	@$(dkr)
	instance: alpine
	run: echo $(PARAM)

back-to-container:
	@$(dkr)
	instance: alpine
	run: apk add curl --no-cache
	run: apk del curl
	run: apk add $$(log: 0 | grep libcurl | cut -d" " -f3)
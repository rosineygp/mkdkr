.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval JOB_NAME=$(shell bash -c 'source .mkdkr; .... $(@)'))
	trap '.' EXIT
endef

test_a:
	@$(.)
	... job alpine
	.. echo "test $(@)"
	.

test_b:
	@$(.)
	... job alpine
	.. echo "test $(@)"
	.

test_c:
	@$(.)
	... job alpine
	.. echo "test $(@)"
	.

build:
	@$(.)
	... job alpine
	.. echo "build $(@)"
	.

pack:
	@$(.)
	... job alpine
	.. echo "pack $(@)"
	.

deploy:
	@$(.)
	... job alpine
	.. echo "stage: $(@)"
	.

test: test_a test_b test_c

pipeline:
	make -f pipeline.mk test -j 3 --output-sync
	make -f pipeline.mk build
	make -f pipeline.mk pack
	make -f pipeline.mk deploy
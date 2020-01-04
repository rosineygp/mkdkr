.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval JOB_NAME=$(shell bash -c 'source .mkdkr; .... $(@)'))
	trap '.' EXIT
endef

# job without destroy at end
broken:
	@$(.)
	... service nginx
	... job alpine
	echo $$JOB_NAME
	.. sleep 2
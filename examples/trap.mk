.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval JOB_NAME=$(shell bash -c 'source .mkdkr; .... $(@)'))
	trap '_destroy_on_exit' EXIT
endef

# job withou destroy at end
broken:
	@$(.)
	... service nginx
	... job alpine
	echo $$JOB_NAME
	.. sleep 2
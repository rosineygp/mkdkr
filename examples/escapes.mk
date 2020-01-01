.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval JOB_NAME=$(shell bash -c 'source .mkdkr; .... $(@)'))
endef

# nothing special here, just add backslashes
multiline:
	@$(.)
	... job alpine
	.. apk add htop \
		vim \
		bash
	.

# add quote in && to not back to local terminal
logical_and:
	@$(.)
	... job ubuntu:18.04
	.. 'apt-get update && \
			apt-get install -y \
			htop \
			vim \
			csh'
	.

# add quote to pipes also
pipes:
	@$(.)
	... job ubuntu:18.04
	.. "find . -iname '*.mk' -type f -exec cat {} \; | grep -c escapes"
	.

# you can redirect a output to outside container
redirect_to_outside:
	@$(.)
	... job ubuntu:18.04
	.. dpkg -l > dpkg_report.txt
	cat dpkg_report.txt            # outside container
	.

all: multiline logical_and pipes redirect_to_outside
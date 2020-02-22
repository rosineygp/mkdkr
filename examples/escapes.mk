include $(shell bash .mkdkr init)

# nothing special here, just add backslashes
multiline:
	@$(dkr)
	instance: alpine
	run: apk add htop \
		vim \
		bash

# add quote in && to not back to local terminal
logical_and:
	@$(dkr)
	instance: ubuntu:18.04
	run: 'apt-get update && \
			apt-get install -y \
			htop \
			vim \
			csh'

# add quote to pipes also
pipes:
	@$(dkr)
	instance: ubuntu:18.04
	run: "find . -iname '*.mk' -type f -exec cat {} \; | grep -c escapes"

# you can redirect a output to outside container
redirect_to_outside:
	@$(dkr)
	instance: ubuntu:18.04
	run: dpkg -l > dpkg_report.txt
	cat dpkg_report.txt            # outside container
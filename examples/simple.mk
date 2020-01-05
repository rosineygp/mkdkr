.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval MKDKR_JOB_NAME=$(shell bash -c 'source .mkdkr; .... $(@)'))
	trap '.' EXIT
endef

simple:
	@$(.)
	... alpine
	.. echo "hello mkdkr!"

# is possible change image during the job
# when it changed the last container is destroyed and the commands are
# addressed to new container
multi-images:
	@$(.)
	... alpine
	.. apk add curl
	.. 'curl -s https://i.kym-cdn.com/entries/icons/mobile/000/018/012/this_is_fine.jpg > img.jpg'
	... ubuntu
	.. apt update -qq
	.. apt install imagemagick -y
	.. convert img.jpg img.png
	... node:10
	.. npm install -g picture-tube
	.. picture-tube img.png
	.. rm img.jpg img.png
	... privileged docker:19
	.. docker build -t my/image .
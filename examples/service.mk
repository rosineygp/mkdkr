include $(shell bash .mkdkr init)

service:
	@$(.)
	... service nginx
	... alpine --link service_$$MKDKR_JOB_NAME:nginx
	.. apk add curl
	.. curl -s nginx

link:
	@$(.)
	... service nginx
	... alpine
	.. apk add curl
	.. curl -s nginx
	... ubuntu:18.04
	.. apt-get update
	.. apt-get install curl -y
	.. curl -s nginx

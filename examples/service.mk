include $(shell bash .mkdkr init)

service:
	@$(dkr)
	service: nginx
	instance: alpine --link service_$$MKDKR_JOB_NAME:nginx
	run: apk add curl
	run: curl -s nginx

link:
	@$(dkr)
	service: nginx
	instance: alpine
	run: apk add curl
	run: curl -s nginx
	instance: ubuntu:18.04
	run: apt-get update
	run: apt-get install curl -y
	run: curl -s nginx

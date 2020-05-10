include $(shell bash .mkdkr init)

slow-service:
	@$(dkr)
	instance: alpine
	run: apk add curl
	service: tomcat --cpus 1
	retry: 60 1 curl http://tomcat:8080
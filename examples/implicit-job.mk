include $(shell bash .mkdkr init)

implicit-job:
	@$(.)
	... alpine --memory 32MB
	.. echo "hello nano job"

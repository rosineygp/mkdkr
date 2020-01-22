include $(shell bash .mkdkr init)

dind:
	@$(.)
	... privileged docker:19
	.. docker build -t rosiney/pylint .

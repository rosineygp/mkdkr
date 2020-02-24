include $(shell bash .mkdkr init)

dind:
	@$(dkr)
	dind: docker:19
	run: docker build -t rosiney/pylint .

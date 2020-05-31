include $(shell bash .mkdkr init)

push-file:
	@$(dkr)
	instance: alpine
	push: /etc/hosts /tmp/pushed-file
	run: cat /tmp/pushed-file

push-folder:
	@$(dkr)
	instance: alpine
	push: . /tmp/project
	run: find /tmp/project -iname *.mk
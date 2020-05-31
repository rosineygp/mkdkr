include $(shell bash .mkdkr init)

pull-file:
	@$(dkr)
	instance: alpine
	pull: /etc/hosts .
	run: cat hosts
	rm hosts

pull-folder:
	@$(dkr)
	instance: alpine
	pull: $(PWD) /tmp/project				# using . can get / from container
	find /tmp/project -iname *.mk		# testing outside container
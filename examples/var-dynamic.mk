include $(shell bash .mkdkr init)

vars:
	@$(dkr)
	instance: alpine
	var-run: "IAM" hostname
	run: echo '$$IAM'
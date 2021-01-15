include $(shell bash .mkdkr init)

vars:
	@$(dkr)
	instance: alpine
	var-run: none whoami
	run: echo $$none
	var-run: 'w' ls /
	run: echo '$$w'
	var-run: "IAM" hostname
	run: echo '$$IAM'
	run: echo "$$IAM"
	echo $$IAM
	# not working in make
	run: echo $(IAM) 
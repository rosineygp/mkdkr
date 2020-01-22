include $(shell bash .mkdkr init)

# without destroy at end
broken:
	@$(.)
	... service nginx
	... alpine
	echo $$MKDKR_JOB_NAME
	.. sleep 2
include $(shell bash .mkdkr init)

test.mock_a:
	@$(dkr)
	instance: alpine
	run: echo "test $(@)"

test.mock_b:
	@$(dkr)
	instance: alpine
	run: echo "test $(@)"

test.mock_c:
	@$(dkr)
	instance: alpine
	run: echo "test $(@)"

build:
	@$(dkr)
	instance: alpine
	run: echo "build $(@)"

pack:
	@$(dkr)
	instance: alpine
	run: echo "pack $(@)"

deploy:
	@$(dkr)
	instance: alpine
	run: echo "stage: $(@)"

test: test.mock_a test.mock_b test.mock_c
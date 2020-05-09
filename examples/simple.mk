include $(shell bash .mkdkr init)

simple:
	@$(dkr)
	instance: alpine
	run: echo "hello mkdkr!"

# is possible change image during the job
# when it changed the last container is destroyed and the commands are
# addressed to new container
multi-images:
	@$(dkr)
	instance: alpine
	run: apk add curl
	run: 'curl -s https://i.kym-cdn.com/entries/icons/mobile/000/018/012/this_is_fine.jpg > img.jpg'
	instance: ubuntu
	run: apt update -qq
	run: ls -la
	dind: docker:19
	run: docker build -t my/image .
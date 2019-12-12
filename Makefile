.EXPORT_ALL_VARIABLES:
SHELL=/bin/bash --init-file .bash -i

.PHONY: shellcheck unnamed service consumer dind brainfuck

all: shellcheck unnamed consumer dind

shellcheck:
	$(eval export name=shellcheck_ubuntu)
	launch ubuntu:18.04
	.= 'apt-get update && \
			apt-get install -y shellcheck'
	.= shellcheck -e SC1088 .bash
	destroy

unnamed:
	launch alpine
	.= apk add htop
	destroy

service:
	$(eval export name=service_nginx)
	service nginx

consumer: service
	$(eval export name=consumer_nginx)
	launch alpine '--link service_nginx:nginx'
	.= apk add curl
	.= curl -s nginx
	destroy
	destroy service_nginx

dind:
	$(eval export name=dind)
	privileged docker:19
	.= docker build -t mdp:dind .
	destroy

brainfuck:
	$(eval export name=brainfuck)
	privileged docker:19
	.= apk add make bash
	.= make all
	destroy

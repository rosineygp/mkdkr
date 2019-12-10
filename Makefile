SHELL=/bin/bash --init-file .bash -i

.PHONY: test build

all: test build

test:
	name=$(shell export name=tetra)
	launch ubuntu:16.04
	.= apt-get update
	.= apt-get install \
		htop \
		vim -y
	.= ps -ef
	destroy

build:
	launch ubuntu:16.04
	.= 'apt-get update && \
		apt-get install htop'
	.= ps -ef
	destroy
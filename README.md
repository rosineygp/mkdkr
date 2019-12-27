[![Build Status](https://travis-ci.org/rosineygp/mkdkr.svg?branch=master)](https://travis-ci.org/rosineygp/mkdkr)
[![pipeline status](https://gitlab.com/rosiney.gp/mkdkr/badges/master/pipeline.svg)](https://gitlab.com/rosiney.gp/mkdkr/commits/master)
[![CircleCI](https://circleci.com/gh/rosineygp/mkdkr/tree/master.svg?style=svg)](https://circleci.com/gh/rosineygp/mkdkr/tree/master)

# mkdkr

<img src="media/logo.svg" alt="logo" align="center" width="128"/>

mkdkr = Makefile + Docker

Super small and powerful framework for make pipelines based on make and docker.

- Dependencies: make, docker and bash
- Less garbage files (Makefile and .mkdkr)
- All power of make
- All power of docker
- All power of bash
- Easy switch between pipeline systems (eg. gitlab, actions, jenkins, ...)

Fast to write and fast to move

```bash
# Download .mkdkr
curl https://raw.githubusercontent.com/rosineygp/mkdkr/master/.mkdkr > .mkdkr
```

> Create a file with name Makefile and paste the following content

```Makefile
.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval JOB_NAME=$(shell bash -c 'source .mkdkr; .... $(@)'))
endef

job:
	@$(.)
	... job alpine
	.. echo "hello mkdkr!
	.
```

```bash
# execute
make job

# Output
... job alpine            # creating a docker container with alpine image
cdab4af95cec...           # docker container id
.. echo hello mkdkr!      # execute command inside container
hello mkdkr!              # output of command
.                         # destroy all containers related of this job
cdab4af95cec              # id(s) of container(s) removed

```


## Reason

Build pipeline for a dedicated platform can take a lot of time to learn and test, with **mkdkr** you can test all things locally and run it before in any pipeline engine like Jenkins, Actions, Gitlab-ci and others.

![standards](https://imgs.xkcd.com/comics/standards.png)

```Bash
# Jenkinsfile DSL
pipeline {
  stage("test") {
    sh "make test"
  }
  stage("build") {
    sh "make build"
  }
  ...
}
```

```yaml
# gitlab-ci
stages:
  - test
  - build

services:
  - docker:19.03.1-dind

image: docker:19

variables:
  DOCKER_HOST: tcp://docker:2376
  DOCKER_TLS_CERTDIR: "/certs"

before_script:
  - apk add make bash

test:
  stage: test
  script:
  - make test

build:
  stage: build
  script:
  - make build

...
```

## How to install

```Shell
# required
curl https://raw.githubusercontent.com/rosineygp/mkdkr/master/.mkdkr > .mkdkr

# not required, but can be used as template
curl https://raw.githubusercontent.com/rosineygp/mkdkr/master/Makefile > Makefile
```

## Pipelines

### local

```Makefile

# included this job
pipeline:
	make shellcheck               # syntax test
	make scenarios -j3            # test scenarios in parallel
```

### External services

- [Circle CI](.circleci/config.yml)
- [Github Actions](.github/workflows/main.yml)
- [Gitlab CI](.gitlab-ci.yml)
- [Travis](.travis.yml)

## . Functions

**ATTENTION:** All functions is a **.** It creates a beautiful code style like yaml, but indents is not required.

```
....  Create or return a job name
      ATTENTION: this is load on $(call .), you probably don't need to use this function.
      parameters:
		  <String job_name>		Set a job_name for current job, if it already run, just return the last name.

...   Create a docker container
      parameters:
          <String action> <String image> <Array args>
          action*     [job, privileged, service]
                      job        => create a docker container used in job
                      privileged => is like a job, but with daemon access
                      service    => start a container but not overwrite the current image cmd
          image*      any docker image, tag is optional
          args        any docker arguments (--cpus 1 --memory 32MB)

..     Execute a command inside docker container
          parameters:
          <Array command>
          command*    any sh command eg. 'apk add nodejs'

.      destroy all containers initialized in a job.
```

### Pipeline generation

```Makefile
# generate pipeline for gitlab
generate/gitlab:
	@$(.)
	... job rosiney/mkdkr
	.. gitlab-ci \
		lint=shellcheck \
		scenarios=simple,service,dind > .gitlab-ci.yml
	.
```
```
Function gitlab-ci parameters
  <stage>=<job>,<job>,...

  The name of key is the **stage** and the **job(s)** is the values separated by comma.
```

> Avoid spaces, slashes or symbols it will keep compatibility with pipeline vendors.

## Create jobs

### Simple job

```Makefile
.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval JOB_NAME=$(shell bash -c 'source .mkdkr; .... $(@)'))
endef

# end of header

# simple job
job:
	@$(.)                             # required to load shell functions and name the job
	... job alpine                    # create a job with alpine container
	.. apk add curl                   # install packages (run inside image)
	.. curl https://www.google.com    # execute curl command (also inside image)
	.                                 # just destroy everything
```
```Shell
make job # execute
```

### Service and Job

Testing a job that depends on another job is very simple.

```Makefile
intergration-test:
	@$(.)                             # required to load shell functions and name the job
	... service nginx                 # start a nginx service
	... job cumcumber \               # start a job with cucumber
		--link service_$$JOB_NAME:nginx
	.. gem install bundler            # build your stuffs
	.. cucumber                       # run the test
	.                                 # this is the end
```

### Privileged (dind)
> Easy Peasy

```Makefile
build:
	@$(.)
	... privileged docker:19             # now its require some privileges
	.. docker build -t awesome:v1.0.0 .
	.
```

### Long commands

```Makefile
multiline:
	@$(.)
	... job ubuntu:18.04
	.. apt-get update '&&' \	# be careful with shell escapes
		apt-get install -y \	# very elegant syntax, remeber tabs!=spaces
		shellcheck \
		htop \
		vim
	.
```

## Execute your jobs

```Shell
# make <job_name>
$ make build
```

## Environment variables

|Name|Default|Description|
|----|-------|-----------|
|TTL|3600|The time limit to a job or service run|

> to overwrite the values use: `export <var>=<value>`

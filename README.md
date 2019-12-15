[![Build Status](https://travis-ci.org/rosineygp/mkdkr.svg?branch=master)](https://travis-ci.org/rosineygp/mkdkr)
[![pipeline status](https://gitlab.com/rosiney.gp/mkdkr/badges/master/pipeline.svg)](https://gitlab.com/rosiney.gp/mkdkr/commits/master)
[![CircleCI](https://circleci.com/gh/rosineygp/mkdkr/tree/master.svg?style=svg)](https://circleci.com/gh/rosineygp/mkdkr/tree/master)

# mkdkr

mkdkr = Make wih Docker

Super small and powerful framework for make pipelines based on Makefile and docker containers.

- Just the make, docker and bash as system requirements
- Just 2 files in your source code (Makefile and .bash)
- All power of make
- All power of docker
- All power of bash
- Easy switch between pipeline systems

Fast to write and fast to move

## Reason

Build pipeline for a dedicated platform can take a lot of time to learn and test, with **Make Docker** your can test all thing locally and run it before in any pipeline engine, like Jenkins, Actions, Gitlab-ci and others.

```Jenkinsfile
# Jenkins
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
  - lint
  - uses case
  - glorious

services:
  - docker:19.03.1-dind

shellcheck:
  stage: lint
  image: docker:19
  variables:
    DOCKER_HOST: tcp://docker:2376
    DOCKER_TLS_CERTDIR: "/certs"
  before_script:
  - apk add make
  - apk add bash
  script:
  - make shellcheck
```

### How to install

```Shell
# required
curl https://raw.githubusercontent.com/rosineygp/mkdkr/master/.mkdkr > .bash

# not required, but can be used as template
curl https://raw.githubusercontent.com/rosineygp/mkdkr/master/Makefile > Makefile
```

### Examples of Pipeline

- [Circle CI](.circleci/config.yml)
- [Github Actions](.github/workflows/main.yml)
- [Gitlab CI](.gitlab-ci.yml)
- [Travis](.travis.yml)

### Special Commands

```
... <action> <image> <args>

  Create a docker container.

  action*  [job, privileged, service]
            job        = just a new docker container
            privileged = a docker container with daemon access
            service    = start de default cmd of container
  image *  any docker image name
  args     any docker arguments use apostrophe eg. '--cpus 1'

., <command>

  Run any command inside a container. In case of special chars like && \n use apostrophe.

  command *  any sh command eg. 'apk add nodejs'

. The end of job, delete all initialized container in make target.
```



### Create a simple and isolated job

```Makefile
.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define .
	source .mkdkr
	JOB_NAME="$(@)_$(shell date +%Y%m%d%H%M%S)"
endef

# end of header

# simple job
job:
  $(call .)                         # required to load shell functions and name the job
  ... job alpine                    # create a job with alpine container
  .. apk add curl                   # install packages (run inside image)
  .. curl https://www.google.com    # execute curl command (also inside image)
  .                                 # just destroy everything
```
```Shell
make job # execute
```

### Create a service and test your webservice

Testing a job that depends of the another job is very simple.

```Makefile
# ---

intergration-test:
  $(call .)                         # required to load shell functions and name the job
  ... service nginx                 # start a nginx service
  ... job cumcumber \               # start a job with cucumber
    --link service_$$JOB_NAME:nginx
  .. gem install bundler            # build your stuffs
  .. cucumber                       # run the test
  .                                 # this is the end
```

```Shell
make cucumber
```

### Needs to build a docker file
> Easy Peasy

```Makefile
build:
  $(call .)
  ... privileged docker:19             # now its require some privileges
  .. docker build -t awesome:v1.0.0 .
  .
```

```Shell
make build
```

### Multiline syntax, everything inside apostrophes

```Makefile
multiline:
  $(call .)
  ... job ubuntu:18.04
  .. apt-get update '&&' \      # be careful with shell escapes
    apt-get install -y \        # very elegant syntax, remeber tabs!=spaces
    shellcheck \
    htop \
    vim
  .
```

```Shell
make multiline
```

## Environment variables

|Name|Default|Description|
|----|-------|-----------|
|TTL|3600|The time limit to a job or service run|

> to overwrite the values use: `export <var>=<value>`
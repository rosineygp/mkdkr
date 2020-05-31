<p align="center">
  <a alt="mkdkr" href="https://rosineygp.github.io/mkdkr">
    <img src="https://github.com/rosineygp/mkdkr/raw/master/media/logo.png?raw=true" width="128"/>
  </a>
</p>

# mkdkr

[![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Frosineygp%2Fmkdkr%2Fbadge%3Fref%3Dmaster&style=flat)](https://actions-badge.atrox.dev/rosineygp/mkdkr/goto?ref=master)
[![Build Status](https://travis-ci.org/rosineygp/mkdkr.svg?branch=master)](https://travis-ci.org/rosineygp/mkdkr)
[![pipeline status](https://gitlab.com/rosiney.gp/mkdkr/badges/master/pipeline.svg)](https://gitlab.com/rosiney.gp/mkdkr/commits/master)
[![CircleCI](https://circleci.com/gh/rosineygp/mkdkr/tree/master.svg?style=svg)](https://circleci.com/gh/rosineygp/mkdkr/tree/master)
[![GitHub license](https://img.shields.io/github/license/rosineygp/mkdkr.svg)](https://github.com/rosineygp/mkdkr/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/rosineygp/mkdkr.svg)](https://GitHub.com/rosineygp/mkdkr/releases/)
[![kcov](https://img.shields.io/endpoint?url=https%3A%2F%2Fmkdkr.surge.sh%2Fcoverage.json)](https://mkdkr.surge.sh/)
[![CodeFactor](https://www.codefactor.io/repository/github/rosineygp/mkdkr/badge)](https://www.codefactor.io/repository/github/rosineygp/mkdkr)
![Docker Pulls](https://img.shields.io/docker/pulls/rosiney/mkdkr)

> mkdkr = Makefile + Docker

Super small and powerful framework for build CI pipeline, scripted with Makefile and isolated with docker.

- Dependencies: [ [make](https://www.gnu.org/software/make/manual/make.html), [docker](https://www.docker.com/), [bash](https://www.gnu.org/software/bash/), [git](https://git-scm.com/) ]
- Two files only (Makefile and .mkdkr), less garbage on your repo
- All power of make, docker and bash
- Shipping and switch among CI engines like
[Circle CI](https://circleci.com/gh/rosineygp/mkdkr),
[GitHub Actions](https://actions-badge.atrox.dev/rosineygp/mkdkr/goto?ref=master),
[Gitlab-ci](https://gitlab.com/rosiney.gp/mkdkr/pipelines), Jenkins, [Travis](https://travis-ci.org/rosineygp/mkdkr/builds).. and more [using exporter](#export)
- Clean and elegant code syntax

<p align="center">
	<a alt="terminalizer" href="https://terminalizer.com/view/a07de9182694">
    	<img src="https://github.com/rosineygp/mkdkr/raw/master/media/presentation.gif?raw=true" />
	</a>
</p>

Table of contents
-----------------

* [Usage](#usage)
  * [Installation](#installation)
  * [Create Makefile](#create-makefile)
  * [Execute](#execute)
  * [Result](#result)
  * [Export](#export)
* [Reason](#reason)
* [Functions](#functions)
  * [@$(dkr)](#dkr)
  * [instance:](#instance)
  * [service:](#service)
  * [dind:](#dind)
  * [run:](#run)
  * [retry:](#retry)
  * [log:](#log)
  * [push:](#push)
  * [pull:](#pull)
* [Includes](#includes)
	* [Explicit](#explicit)
	* [Implicit](#implicit)
	* [mkdkr.csv](#mkdkr.csv)
	* [Collection](#collection)
* [Helpers](#helpers)
* [Examples](#examples)
  * [Simple](#simple)
  * [Service](#service)
  * [DIND](#dind)
  * [Escapes](#escapes)
  * [Shell](#shell)
  * [Stdout](#stdout)
  * [Pipelines](#pipelines)
* [Environment Variables](#environment-variables)
* [Migration](#migration)

# Usage

## Installation

```bash
# Download .mkdkr
curl https://raw.githubusercontent.com/rosineygp/mkdkr/master/.mkdkr > .mkdkr

# not required, but can be used as template
curl https://raw.githubusercontent.com/rosineygp/mkdkr/master/examples/simple.mk > Makefile
```

## Makefile

Create a file with name Makefile and paste the following content

```Makefile
# Required header
include $(shell bash .mkdkr init)

job:	                          # job name
	@$(dkr)                       # required: load mkdkr (docker layer)
	instance: alpine              # create a docker container using alpine image
	run: echo "hello mkdkr!"      # execute a command inside container
```

## Execute

```bash
# execute
make job
```

## Result

```bash
start: job


instance: alpine 
20498831fe05f5d33852313a55be42efd88b1fb38b463c686dbb0f2a735df45c

run: echo hello mkdkr!
hello mkdkr!

cleanup:
20498831fe05

completed:
0m0.007s 0m0.000s
0m0.228s 0m0.179s
```

## Export

Run your current Makefile in another engine, like **travis** or **github actions**, use the dynamic include [exporter](https://github.com/rosineygp/mkdkr_exporter).

# Reason

Build pipeline for a dedicated platform can take a lot of time to learn and test, with **mkdkr** you can test all things locally and run it in any pipeline engine like Jenkins, Actions, Gitlab-ci and others.


<p align="center">
  <a href="ttps://imgs.xkcd.com/comics/standards.png">
    <img alt="standards" src="https://imgs.xkcd.com/comics/standards.png" />
  </a>
</p>

# Functions

## @$(dkr)

Load docker layer for mkdkr, use inside a target of Makefile.

```Makefile

shell-only:
	echo "my local shell job"

mkdkr-job:
	@$(dkr)            # load all deps of mkdkr
	intance: alpine
	run: echo "my mkdkr job"
```

## instance:

Create docker containers, without special privileges.

```Makefile
my-instance:
	@$(dkr)
	instance: ubuntu:20.04     # create a instance
```

**Parameters:**

- String, DOCKER_IMAGE *: any docker image name
- String|Array, ARGS: additional docker init args like (--cpus 1 --memory 64MB)

**Return:**
- String, Container Id

> Calling **instance:** twice, it will replace the last container.

## service:

Create a docker container in detached mode. Useful to bring up a required service for a job, like a webserver or database.

```Makefile
my-service:
	@$(dkr)
	service: nginx    # up a nginx
	instance: alpine
```
Is possible start more than one service.

```Makefile
multi-service:
	@$(dkr)
	service: mysql
	service: redis
	instance: node:12
	run: npm install
	run: npm test
```

> \* Instance and services are connected in same network<br>
> \*\* The name of service is the same of image name with safe values

| Image Name                 | Network Name               |
|----------------------------|----------------------------|
| nginx                      | nginx                      |
| nginx:1.2                  | nginx_1_2                  |
| redis:3                    | redis_3                    |
| project/apache_1.2         | project_apache_1_2         |
| registry/my/service:latest | registry_my_service_latest |

> replace role `'s/:|\.|\/|-/_/g'`

**Parameters:**

- String, DOCKER_IMAGE *: any docker image name
- String|Array, ARGS: additional docker init args like (--cpus 1 --memory 64MB)

**Return:**
- String, Container Id

> instance or dind created after a service, will be automatically linked.

## dind:

Create a docker instance with daemon access. Useful to build docker images.

```Makefile
my-dind:
	@$(dkr)
	dind: docker:19
	run: docker build -t my/dind .
```
**Parameters:**

- String, DOCKER_IMAGE *: any docker image name
- String|Array, ARGS: additional docker init args like (--cpus 1 --memory 64MB)

**Return:**
- String, Container Id

## run:

Execute a command inside docker container [**instance:** or **dind:**] (the last one).

> Is not possible to execute commands in a **service**.

**Parameters:**
- String|Array, command: any sh command eg. 'apk add nodejs'

**Return:**
- String, Command(s) output

**Usage**

```Makefile
my-run:
	@$(dkr)
	instance: alpine
	# run a command inside container
	run: apk add curl

	instance: debian
	# avoid escape to host bash, escapes also can be used (eg. \&\&)
	run: 'apt-get update && \
			apt-get install -y curl'

	# run a command inside container and redirect output to host
	run: ls -la > myfile

	# run a command inside container and redirect output to container
	run: 'ls -la > myfile'
```

## retry:

Execute a command inside docker container [**instance:** or **dind:**] (the last one), with retry options.

> Is not possible to execute commands in a **service**.

**Parameters:**
- Number|Int, attempts: number of attempts before crash.
- Number|Int, sleep: time sleeping before retry.
- String|Array, command: any sh command eg. 'curl https://tomcat:8080'

**Return:**
- String, Command(s) output

**Usage**

```Makefile
deploy:
	@$(dkr)
	instance: oc
	retry: 3 10 oc apply -f build.yml
	#the job can run 3 times with a delay of ten seconds

npm:
	instance: alpine
	run: apk add curl
	service: my-slow-service
	retry: 60 1 curl http://my-slow-service:8080
```

## log:

All output steps executed in a job (except log:) is stored and can be reused during future steps.

**Parameters:**
- Number: The number represent the step in a job and start with 0.

**Return:**
- Text, Multiline text.

**Usage**

```Makefile
my-log:
	@$(dkr)
	instance: alpine
	run: apk add curl jq
	run: curl http://example.com
	log: 1 \| jq '.'
```

## push:

Push files/folders to a container job from local filesystem.

**Parameters:**
- String, from: Target files/folders in local filesystem.
- String, to: Destiny of files/folders inside container.

**Return**
- None.

**Usage**

```Makefile
push:
	@$(dkr)
	instance: ansible
	push: /etc/ansible/inventory/hosts.yml
	run: ansible-playbook main.yml
```

[Example](examples/push.mk)

## pull:

Pull files/folders from a container job to local filesystem.

**Parameters:**
- String, from: Target files/folders inside container.
- String, to: Destiny of files/folders in local filesystem.

**Return**
- None.

**Usage**

```Makefile
pull:
	@$(dkr)
	instance: debian
	run: curl https://example.com -o /tmp/out.html
	pull: /tmp/out.html .
```

[Example](examples/pull.mk)

# Includes

Is possible create jobs or fragments of jobs and reuse it in another projects, like a code package library.

There are two major behavior of includes:

## Explicit

A fragment of job (eg. `define`) and needs to be called explicitly to work.

```Makefile
TAG=latest

define docker_build =
	@$(dkr)
	dind: docker:19
	run: docker build -t $(REGISTRY)/$(PROJECT)/$(REPOS):$(TAG) .
endef
```
All definitions will be load at start of makefile, after it is possible to call at your custom job.

```Makefile
my-custom-build:
	$(docker-build)
```

## Implicit

Just a full job in another project.

```Makefile
TAG=latest

docker_build:
	@$(dkr)
	dind: docker:19
	run: docker build -t $(REGISTRY)/$(PROJECT)/$(REPOS):$(TAG) .
```

The jobs will be load at start and can be called directly.

```shell
make docker_build
```

> - No needs to implement the job at main Makefile.
> - Very useful for similar projects.

## mkdkr.csv

A file with name `mkdkr.csv`, that contains the list of remote includes.

Needs to be at same place o main Makefile.

```csv
commitlint,https://github.com/rosineygp/mkdkr_commitlint.git,master,main.mk
docker,https://github.com/rosineygp/mkdkr_docker.git
```

The file contains four values per line in following order

| # | Name        | Definition                                                       |
|---|-------------|------------------------------------------------------------------|
| 1 | alias *     | unique identifier of include and clone folder destiny            |
| 2 | reference * | any git clone reference                                          |
| 3 | checkout    | branch, tag or hash that git can checkout (default master)       |
| 4 | file        | the fragment of Makefile that will be included (default main.mk) |

> \* required

## Collection

| Name                                                         | Description                                        |
|--------------------------------------------------------------|----------------------------------------------------|
| [docker](https://github.com/rosineygp/mkdkr_docker)          | Build and Push Docker images.                      |
| [commit lint](https://github.com/rosineygp/mkdkr_commitlint) | Validate commit message with semantic commit.      |
| [exporter](https://github.com/rosineygp/mkdkr_exporter)      | Generate pipeline definitions files from Makefile. |

> Small collection, use it as example

# Helpers

A set of small functions to common pipelines process.

| Name           | Description                                                  | Usage                                        | Output |
|----------------|--------------------------------------------------------------|----------------------------------------------|--------|
| slug           | Replace unsafe values from a string                          | `slug <string>`                              | string |
| urlencode      | Encode a string to URL format                                | `urlencode <string>`                         | string |
| urldecode      | Decode a string from URL format                              | `urldecode <string>`                         | string |
| uuid           | Generate UUID                                                | `uuid`                                       | string |
| ssh-cp-key     | Copy ssh private key for current user                        | `ssh-cp-key <key-path>`                      | none   |
| ssh-host-check | Set StrictHostKeyChecking=no                                 | `ssh-host-check <hostname:port>`             | none   |
| git-user       | Configure git.user and git.email                             | `git-user <email>`                           | none   |
| git-ssh        | Configure ssh and git [ssh-cp-key, ssh-host-check, git-user] | `git-ssh <key-path> <hostname:port> <email>` | none   |

```Makefile
autocommit:
	@$(dkr)
	instance: alpine/git
	git-ssh: ~/.ssh/id_rsa github.com auto@mkdkr.com
	run: git clone git@github.com:rosineygp/mkdkr.git /auto
	run: echo "my new file" \> /auto/my-new-file.txt
	run: git -C /auto add my-new-file.txt
	run: git -C /auto commit -m "my automatic change"
	run: git -C /auto push origin master:feat/auto-push
```

# Examples

## Simple

```Makefile
simple:
	@$(dkr)
	instance: alpine
	run: echo "hello mkdkr!"
```

> Is possible to mix images during job, see in example

[Makefile](examples/simple.mk)

## Service

```Makefile
service:
	@$(dkr)
	service: nginx
	instance: alpine
	run: apk add curl
	run: curl -s nginx
```

[Makefile](examples/service.mk)

## DIND

Privileged job

```Makefile
dind:
	@$(dkr)
	dind: docker:19
	run: docker build -t project/repos .
```

[Makefile](examples/dind.mk)

## Escapes

```Makefile
pipes:
	@$(dkr)
	instance: ubuntu:18.04
	run: "find . -iname '*.mk' -type f -exec cat {} \; | grep -c escapes"
```

> More examples at file

[Makefile](examples/escapes.mk)

## Shell

Switch to another shell

```Makefile
shell:
	@$(dkr)
	instance: ubuntu
	export MKDKR_SHELL=bash
	run: 'echo $$0'
```

> More examples at file

[Makefile](examples/shell.mk)

## Stdout

Get output by id

Use to filter or apply some logic in last command executed

```Makefile
stdout:
	@$(dkr)
	instance: alpine
	run: echo "hello mkdkr!"
	run: ps -ef
	log: 1
```

> `log: 1` return stout form second command `ps -ef`

```Makefile
stdout:
	@$(dkr)
	instance: debian
	run: apt-get update
	run: apt-get install curl -y
	run: dpkg -l
	log: 2 | grep -i curl && echo "INSTALLED"
```
> `log: 2` return stdout from third command  `dpkg -l` and apply filter

[Makefile](examples/stdout.mk)

## Pipelines

Group of jobs for parallel and organization execution

```Makefile
pipeline:
	make test -j 3	# parallel execution
	make build
	make pack
	make deploy
```

[Makefile](examples/pipeline.mk)

# Environment Variables

| Name                      | Default                             | Description                                                 |
|---------------------------|-------------------------------------|-------------------------------------------------------------|
| MKDKR_TTL                 | 3600                                | The time limit to a job or service run                      |
| MKDKR_SHELL               | sh                                  | Change to another shell eg. bash, csh                       |
| MKDKR_JOB_STDOUT          | last stdout                         | Path of file, generated with last stdout output             |
| MKDKR_JOB_NAME*           | (job\|service)\_target-name\_(uuid) | Unique job name, used as container name suffix              |
| MKDKR_INCLUDE_CLONE_DEPTH | 1                                   | In the most of case you no need change history for includes |
| MKDKR_BRANCH_NAME         |                                     | Return current git branch, if it exist                      |
| MKDKR_BRANCH_NAME_SLUG    |                                     | Return current git branch, if it exist, with safe values    |
| MKDKR_NETWORK_ARGS        |                                     | Arguments of docker create networks                         |

> - to overwrite the values use: `export <var>=<value>`
> - \* auto generated

# Migration

Migration from release-0.26, just execute the following script on your terminal at root of your project.

```bash
curl https://raw.githubusercontent.com/rosineygp/mkdkr/master/.mkdkr > .mkdkr

mkdkr_migration() {
  sed -i 's/\.\.\.\ job\ /instance:\ /g;s/\.\.\.\ service\ /service:\ /g;s/\.\.\.\ privileged\ /dind:\ /g;s/\.\.\.\ /instance:\ /g;s/\.\.\ /run:\ /g;s/@\$(\.)/@\$(dkr)/g' ${1}
}

export -f mkdkr_migration

mkdkr_migration Makefile

find . -iname *.mk -exec bash -c 'mkdkr_migration "$0"' {} \;

```

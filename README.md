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

> mkdkr = Makefile + Docker

Super small and powerful framework for build CI pipeline, scripted with Makefile and isolated with docker.

- Dependencies: [ [make](https://www.gnu.org/software/make/manual/make.html), [docker](https://www.docker.com/), [bash](https://www.gnu.org/software/bash/), [git](https://git-scm.com/) ]
- Two files only (Makefile and .mkdkr), less garbage on your repo
- All power of make, docker and bash
- Shipping and switch among CI engines like
[Circle CI](https://circleci.com/gh/rosineygp/mkdkr),
[GitHub Actions](https://actions-badge.atrox.dev/rosineygp/mkdkr/goto?ref=master),
[Gitlab-ci](https://gitlab.com/rosiney.gp/mkdkr/pipelines), Jenkins, [Travis](https://travis-ci.org/rosineygp/mkdkr/builds).. and more
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
* [Reason](#reason)
* [Dot Functions](#dot-functions)
  * [•••](#-3-dots)
  * [••](#-2-dots)
* [Includes](#includes)
	* [Explicit](#explicit)
	* [Implicit](#implicit)
	* [mkdkr.csv](#mkdkr.csv)
	* [Collection](#collection)
* [Examples](#examples)
  * [Simple](#simple)
  * [Service](#service)
  * [DIND](#dind)
  * [Escapes](#escapes)
  * [Shell](#shell)
  * [Trap](#trap)
  * [Implicit Job](#implicit-job)
  * [Sdtout](#stdout)
  * [Pipelines](#pipelines)
* [Generators](#generators)
  * [Gitlab CI](#gitlab-ci)
* [Environment Variables](#environment-variables)

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

job:                                # job name
	@$(.)                       # required: load mkdkr and create unique job name
	... alpine                  # create a docker container using alpine image
	.. echo "hello mkdkr!"      # execute a command inside container

# if you want to test it remove all comments of job
```

## Execute

```bash
# execute
make job
```

## Result

```bash
# output
... job alpine            # creating a docker container using alpine image
cdab4af95cec...           # docker container id
.. echo hello mkdkr!      # execute command inside container
hello mkdkr!              # output of command
.                         # destroy all containers related of this job
cdab4af95cec              # id(s) of container(s) removed

```

# Reason

Build pipeline for a dedicated platform can take a lot of time to learn and test, with **mkdkr** you can test all things locally and run it in any pipeline engine like Jenkins, Actions, Gitlab-ci and others.


<p align="center">
  <a href="ttps://imgs.xkcd.com/comics/standards.png">
    <img alt="standards" src="https://imgs.xkcd.com/comics/standards.png" />
  </a>
</p>

# Dot Functions

**ATTENTION:** All functions are represented with **.(s)** It creates a beautiful code style like yaml, indents are not required.

```Makefile
job:
	...
	..
```

> yes, just dots

## ••• 3 dots

Create a docker container, it can set as **simple** job, **service** or **privileged** job.

**Parameters:**
- String, ACTION: Actions is the mode that container will run it can be a:
  - job **[default]**: simple docker container
  - service: is like a job, but run in detached mode
  - privileged: is a job but with docker socket access

> if any action was passed, it will be a job

- String, IMAGE *: any docker image name
- String|Array, ARGS: additional docker init args like (--cpus 1 --memory 64MB)

**Return:**
- String, Container Id

**Usage**

```Bash
# simple job
... job alpine

# if it's a job, pass action [job] is not required
... ubuntu:18.04

# container with parameters
... centeos:7 \
    --cpus 2 \
    --memory 1024MB \
    -e PASSWORD=$$PASSWORD

# create a service
... service nginx

# create a job with docker demon access
... privileged docker:19
```

> \*\* Required when is a service or a privileged container

## •• 2 dots

Execute a command inside docker container [**job** or **privileged**].

> Is not possible to execute commands in a **service**.

**Parameters:**
- String|Array, command: any sh command eg. 'apk add nodejs'

**Return:**
- String, Command(s) output

**Usage**

```Bash

# run a command inside container
.. apk add curl

# avoid escape to host bash, escapes also can be used (eg. \&\&)
.. 'apt-get update && \
    apt-get install -y curl'

# run a command inside container and redirect output to host
.. ls -la > myfile

# run a command inside container and redirect output to container
.. 'ls -la > myfile'
```

# Includes

Is possible create jobs or fragments of jobs and reuse it in another projects, like a code package library.

There are two major behavior of includes:

## Explicit

> Recommend

A fragment of job (eg. `define`) and needs to be called explicitly to work.

```Makefile
TAG=latest

define docker_build =
	@$(.)
	... privileged docker:19
	.. docker build -t $(REGISTRY)/$(PROJECT)/$(REPOS):$(TAG) .
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
	@$(.)
	... privileged docker:19
	.. docker build -t $(REGISTRY)/$(PROJECT)/$(REPOS):$(TAG) .
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

|#|Name|Definition|
|-|----|----------|
|1|alias *|unique identifier of include and clone folder destiny|
|2|reference *|any git clone reference|
|3|checkout|branch, tag or hash that git can checkout (default master)|
|4|file|the fragment of Makefile that will be included (default main.mk)|

> \* required

## Collection

* [docker](https://github.com/rosineygp/mkdkr_docker)
* [commit lint](https://github.com/rosineygp/mkdkr_commitlint)

> Small collection, use it as example

# Examples

## Simple

```Makefile
simple:
	@$(.)
	... job alpine
	.. echo "hello mkdkr!"
```

> Is possible to mix images during job, see in example

[Makefile](examples/simple.mk)

## Service

```Makefile
service:
	@$(.)
	... service nginx
	... alpine --link service_$$MKDKR_JOB_NAME:nginx
	.. apk add curl
	.. curl -s nginx
```

[Makefile](examples/service.mk)

## DIND

Privileged job

```Makefile
dind:
	@$(.)
	... privileged docker:19
	.. docker build -t rosiney/pylint .
```

[Makefile](examples/dind.mk)

## Escapes

```Makefile
pipes:
	@$(.)
	... ubuntu:18.04
	.. "find . -iname '*.mk' -type f -exec cat {} \; | grep -c escapes"
```

> More examples at file

[Makefile](examples/escapes.mk)

## Shell

Switch to another shell

```Makefile
shell:
	@$(.)
	... ubuntu
	export MKDKR_SHELL=bash
	.. 'echo $$0'
```

> More examples at file

## Trap

Prevent keep container running when after error or exit.

```Makefile
broken:
	@$(.)
	... service nginx
	... alpine
	.. ps -ef
```

> Job finished without call **.**, now trap close it correctly.

[Makefile](examples/trap.mk)

## Implicit Job

When start a new job if [action](#-3-dots) passed, it will create a container as a simple job.

```Makefile
implicit-job:
	@$(.)
	... alpine --memory 32MB
	.. echo "hello nano job"
```

> implicit='Less code!'

[Makefile](examples/implicit-job.mk)

## Stdout

Get last command output

Use to filter or apply some logic in last command executed (also outside container)

```Makefile
stdout:
	@$(.)
	... alpine
	.. echo "hello mkdkr!"
	cat "$(MKDKR_JOB_STDOUT)"
```

> `$(MKDKR_JOB_STDOUT)` return path of file

```Makefile
stdout:
	@$(.)
	... debian
	.. apt-get update
	.. apt-get install curl -y
	.. dpkg -l
	$(stdout) | grep -i curl && echo "INSTALLED"
```
> `$(stdout)` return output file using cat

[Makefile](examples/stdout.mk)

## Pipeline

Group of jobs for parallel and organization execution

```Makefile
pipeline:
	make test -j 3	# parallel execution
	make build
	make pack
	make deploy
```

[Makefile](examples/pipeline.mk)

# Generators

Create a scaffold to another pipeline engine.

External pipeline:

- [Circle CI](.circleci/config.yml)
- [Github Actions](.github/workflows/main.yml)
- [Gitlab CI](.gitlab-ci.yml)
- [Travis](.travis.yml)

## Gitlab CI

```Makefile
gitlab:
	@$(.)
	... rosiney/mkdkr
	.. gitlab-ci \
		lint=shellcheck \
		scenarios=simple,service,dind > .gitlab-ci.yml
```

**Parameters:**
- String(key)=String(job),String(job),...	The name of key is the **stage** and the **job(s)** is the values separated by comma.

> - Ex. test=lint,syntax build=gcc deploy=k8s
> - Avoid spaces, slashes or symbols it will keep compatibility with pipeline vendors.

# Environment Variables

|Name|Default|Description|
|----|-------|-----------|
|MKDKR_TTL|3600|The time limit to a job or service run|
|MKDKR_SHELL|sh|Change to another shell eg. bash, csh|
|MKDKR_JOB_STDOUT|last stdout|Path of file, generated with last stdout output|
|MKDKR_JOB_NAME*|(job\|service)\_target-name\_(uuid)|Unique job name, used as container name suffix|
|MKDKR_INCLUDE_CLONE_DEPTH|1|In the most of case you no need change history for includes|

> - to overwrite the values use: `export <var>=<value>`
> - \* auto generated
<p align="center">
  <a alt="mkdkr" href="https://rosineygp.github.io/mkdkr">
    <img src="https://github.com/rosineygp/mkdkr/raw/master/media/logo.png?raw=true" width="128"/>
  </a>
</p>

# mkdkr

[![Build Status](https://travis-ci.org/rosineygp/mkdkr.svg?branch=master)](https://travis-ci.org/rosineygp/mkdkr)
[![pipeline status](https://gitlab.com/rosiney.gp/mkdkr/badges/master/pipeline.svg)](https://gitlab.com/rosiney.gp/mkdkr/commits/master)
[![CircleCI](https://circleci.com/gh/rosineygp/mkdkr/tree/master.svg?style=svg)](https://circleci.com/gh/rosineygp/mkdkr/tree/master)
[![GitHub license](https://img.shields.io/github/license/rosineygp/mkdkr.svg)](https://github.com/rosineygp/mkdkr/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/rosineygp/mkdkr.svg)](https://GitHub.com/rosineygp/mkdkr/releases/)
[![kcov](https://img.shields.io/endpoint?url=https%3A%2F%2Fmkdkr.surge.sh%2Fcoverage.json)](https://mkdkr.surge.sh/)
[![CodeFactor](https://www.codefactor.io/repository/github/rosineygp/mkdkr/badge)](https://www.codefactor.io/repository/github/rosineygp/mkdkr)

> mkdkr = Makefile + Docker

Super small and powerful framework for build CI pipeline, scripted with Makefile and isolated with docker.

- Dependencies: [ [make](https://www.gnu.org/software/make/manual/make.html), [docker](https://www.docker.com/), [bash](https://www.gnu.org/software/bash/) ]
- Two files only (Makefile and .mkdkr), less garbage on your repo
- All power of make, docker and bash
- Shipping and switch among CI engines like 
[Circle CI](https://circleci.com/gh/rosineygp/mkdkr),
[GitHub Actions](https://github.com/rosineygp/mkdkr/runs/374344269), 
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
  * [••••](#-4-dots)
  * [•••](#-3-dots)
  * [••](#-2-dots)
  * [•](#-1-dot)
* [Examples](#examples)
  * [Simple](#simple)
  * [Service](#service)
  * [DIND](#dind)
  * [Escapes](#escapes)
  * [Shell](#shell)
  * [Trap](#trap)
  * [Implicit Job](#implicit-job)
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
	....
	...
	..
	.
```

> yes, just dots

## •••• 4 dots

[auto] Create a unique job name.

**Parameters:**
- String, MKDKR_JOB_NAME: If not exist set a MKDKR_JOB_NAME otherwise return current MKDKR_JOB_NAME.

**Return:**
- String, MKDKR_JOB_NAME

> Automatically load after call `@$(.)`.

**Usage**

```Bash
.... my-awesome-job		# name a job
```

## ••• 3 dots

[optional**] Create a docker container, it can set as simple job, service or privileged job.

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
... job alpine                  # simple job
... ubuntu:18.04                # if it's a job, pass action [job] is not required
... centeos:7 \
    --cpus 2 \
    --memory 1024MB \
    -e PASSWORD=$$PASSWORD      # container parameters
... service nginx               # create a service
... privileged docker:19        # create a job with docker demon access
```

> \*\* Required when is a service or a privileged container

## •• 2 dots

[required] Execute a command inside docker container [job or privileged].

**Parameters:**
- String|Array, command: any sh command eg. 'apk add nodejs'

**Return:**
- String, Command(s) output

**Usage**

```Bash
.. apk add curl                # run a command inside container
.. ls -la > myfile             # run a command inside container and redirect output to host
.. 'ls -la > myfile'           # run a command inside container and redirect output to container
.. 'apt-get update && \
    apt-get install -y curl'   # just need '' cause && redirect outside container
```

## • 1 dot

[optional] Destroy all containers initialized in a job.

> At end of job it is called implicitly.

**Parameters:**
- None

**Return:**
- String, Container Id

**Usage**

```Bash
.   # Kill 'Em All
```

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
|MKDKR_JOB_NAME*|(job\|service)\_target-name\_(uuid)|Unique job name, used as container name suffix|

> - to overwrite the values use: `export <var>=<value>`
> - \* auto generated 
<p align="center">
  <a alt="mkdkr" href="https://rosineygp.github.io/mkdkr">
    <img src="media/logo.png?raw=true" width="128"/>
  </a>
</p>

# mkdkr

[![Build Status](https://travis-ci.org/rosineygp/mkdkr.svg?branch=master)](https://travis-ci.org/rosineygp/mkdkr)
[![pipeline status](https://gitlab.com/rosiney.gp/mkdkr/badges/master/pipeline.svg)](https://gitlab.com/rosiney.gp/mkdkr/commits/master)
[![CircleCI](https://circleci.com/gh/rosineygp/mkdkr/tree/master.svg?style=svg)](https://circleci.com/gh/rosineygp/mkdkr/tree/master)
[![GitHub license](https://img.shields.io/github/license/rosineygp/mkdkr.svg)](https://github.com/rosineygp/mkdkr/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/rosineygp/mkdkr.svg)](https://GitHub.com/rosineygp/mkdkr/releases/)
[![kcov](https://mkdkr.surge.sh/coverage.svg)](https://mkdkr.surge.sh/)

> mkdkr = Makefile + Docker

Super small and powerful framework for build CI pipeline, scripted with Makefile and isolated with docker.

- Dependencies: [ [make](https://www.gnu.org/software/make/manual/make.html), [docker](https://www.docker.com/), [bash](https://www.gnu.org/software/bash/) ]
- Two files only (Makefile and .mkdkr), less garbage on your repo
- All power of make, docker and bash
- Shipping and switch among CI engines like GitHub Actions, Gitlab-ci, Jenkins, Travis.. and more
- Clean and elegant code syntax

<p align="center">
	<a href="https://terminalizer.com/view/a07de9182694">
    	<img src="media/presentation.gif?raw=true" />
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
.EXPORT_ALL_VARIABLES:
.ONESHELL:
SHELL = /bin/bash

define . =
	source .mkdkr
	$(eval JOB_NAME=$(shell source .mkdkr; .... $(@)))
	trap '_destroy_on_exit' EXIT
endef
# end of header

job:                                # job name
	@$(.)                       # required: load mkdkr and create unique job name
	... job alpine              # create a docker container using alpine image
	.. echo "hello mkdkr!"      # execute a command inside container
	.                           # destroy all container started in this job

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
- String, JOB_NAME: If not exist set a JOB_NAME otherwise return current JOB_NAME.

**Return:**
- String, JOB_NAME

> Automatically load after call `@$(.)`.

## ••• 3 dots

[required] Create a docker container, it can set as simple job, service or privileged job.

**Parameters:**
- String, ACTION *: Actions is the mode that container will run it can be a:
  - job: simple docker container
  - service: is like a job, but run in detached mode
  - privileged: is a job but with docker socket access
- String, IMAGE *: any docker image name
- String|Array, ARGS: additional docker init args like (--cpus 1 --memory 64MB)

**Return:**
- String, Container Id

## •• 2 dots

[required] Execute a command inside docker container (job or privileged).

**Parameters:**
- String|Array, command: any sh command eg. 'apk add nodejs'

**Return:**
- String, Command(s) output


## • 1 dot

[optional] Destroy all containers initialized in a job.

> At end of job it is called implicitly.

**Parameters:**
- None

**Return:**
- String, Container Id

# Examples

## Simple

```Makefile
simple:
	@$(.)
	... job alpine
	.. echo "hello mkdkr!"
	.
```

[Makefile](examples/simple.mk)

## Service


```Makefile
service:
	@$(.)
	... service nginx
	... job alpine --link service_$$JOB_NAME:nginx
	.. apk add curl
	.. curl -s nginx
	.
```

[Makefile](examples/service.mk)

## DIND

Privileged job

```Makefile
dind:
	@$(.)
	... privileged docker:19
	.. docker build -t rosiney/pylint .
	.
```

[Makefile](examples/dind.mk)

## Escapes

```Makefile
pipes:
	@$(.)
	... job ubuntu:18.04
	.. "find . -iname '*.mk' -type f -exec cat {} \; | grep -c escapes"
	.
```

> More examples at file

[Makefile](examples/escapes.mk)

## Shell

Switch to another shell

```Makefile
shell:
	@$(.)
	... job ubuntu
	export MKDKR_SHELL=bash
	.. 'echo $$0'
	.
```

> More examples at file

[Makefile](examples/shell.mk)

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
	... job rosiney/mkdkr
	.. gitlab-ci \
		lint=shellcheck \
		scenarios=simple,service,dind > .gitlab-ci.yml
	.
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

> to overwrite the values use: `export <var>=<value>`

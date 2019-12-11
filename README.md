# Make It In Box

Super small and powerfull framework for make pipilines based on Makefile and docker containers.

- Just the make, docker and bash as system requirements
- Just 2 files in your source code (Makefile and .bash)
- All power of make
- All power of docker
- All power of bash

Fast to write and fast to move

## Reason

Build pipeline for one platform can take a lot of time to learn and test, with MakeItInBox your can test all thing locally and run it before in any pipeline engine, like Jenkins, Actions, Gitlab and others.

```Jenkinsfile
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

### How to install

```Shell
# required
curl https://raw.githubusercontent.com/rosineygp/mdp/master/.bash > .bash

# not required, but can be used as template
curl https://raw.githubusercontent.com/rosineygp/mdp/master/Makefile > Makefile
```

### Create a simple and isolated job

```Makefile
# makefile header
.EXPORT_ALL_VARIABLES:
SHELL=/bin/bash --init-file .bash -i # load the bash requirement

.PHONY: job
# end of header

# simple job
job:
  $(eval export name=alpine_curl_check)   # set the name of docker instance
  launch alpine                           # create instance name
  .= apk add curl                         # install packages (run inside image)
  .= curl https://www.google.com          # execute command
  destroy                                 # just destroy the image
```
```Shell
make job # execute
```

### Too slow you can go fast with unnamed jobs

```Makefile
# put all the header above here and the .PHONY
ping:
  launch alpine
  .= apk add iputils
  .= ping -c 1.1.1.1
  destroy
```

```Shell
make ping
```

The name of docker instance will be named as **unnamed**, don't use it with concurrent jobs

### Create a service and test your webservice

Testing a job that depends of the another job is very simple.

```Makefile
static:
  $(eval export name=service_nginx)
  service nginx                                 # here use service

cucumber: service
  $(eval export name=consumer_nginx)
  launch cucumber '--link service_nginx:nginx'
  .= gem install bundler
  .= cucumber
  destroy
  destroy service_nginx                        # do not forget to destroy the service
```

```Shell
make cucumber
```

### Needs to build a docker file
> Easy Peasy

```Makefile
build:
  $(eval export name=builder)
  privileged docker:19                       # now whe require some privileages
  .= docker build -t awesome:v1.0.0 .
  destroy
```

```Shell
make build
```

### Multiline syntax, everything inside apostrophes

```Makefile
multiline:
  $(eval export name=shellcheck_ubuntu)
  launch ubuntu:18.04
  .= 'apt-get update && \
        apt-get install -y shellcheck'      # very elegant code
  .= shellcheck -e SC1088 .bash
  destroy
```

```Shell
make multiline
```

## Environment variables

|Name|Default|Description|
|----|-------|-----------|
|ttl|3600|The time limit to a job or service run|

> to overwrite the values use: `export <var>=<value>`
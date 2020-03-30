# Contributing Guide

## System Requirements

- make
- docker
- git
- nodejs >= 10

## Begin

After install system requirements run the following commands.

```Shell
npm install
```

## Shellcheck

The code syntax is verified by shellcheck.

> Before commit

## Commit Message

The project uses [conventional commit](https://www.conventionalcommits.org/en/v1.0.0/) for validate commit message.

> After commit

## Unit Testing

```Shell
make test.unit
```

## Integration tests and compatibility matrix

To run all tests locally use:

```Shell
./pipeline.sh
```

> You can test the code at github, just enable pipeline at your fork.

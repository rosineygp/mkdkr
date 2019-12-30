# How to run examples

Just use the command make inside this folder with -f parameter.

```bash

# simple
make -f simple.mk simple

# service
make -f service.mk service

# dind
make -f dind.mk dind

# escapes
make -f escapes.mk multiline
make -f escapes.mk pipes
make -f escapes.mk logical_and
make -f escapes.mk redirect_to_outside

# pipeline
make -f pipeline.mk pipeline
```

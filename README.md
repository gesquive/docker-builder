# master-builder
[![pipeline status](https://img.shields.io/gitlab/pipeline/gesquive/master-builder?style=flat-square)](https://gitlab.com/gesquive/master-builder/pipelines)

Docker build image for x86_64/amd64 that can build multi-arch docker images.

Architectures supported include:
 - x86_64
 - i386
 - arm

Includes the following build tools:

 - [qemu](https://www.qemu.org/)
 - [docker](https://docs.docker.com/install/)
 - [docker-buildkit](https://docs.docker.com/buildx/working-with-buildx/)

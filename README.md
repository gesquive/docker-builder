# docker-builder
[![Pipeline Status](https://img.shields.io/circleci/build/github/gesquive/docker-builder?style=flat-square)](https://gitlab.com/gesquive/docker-builder/pipelines)
[![Docker Pulls](https://img.shields.io/docker/pulls/gesquive/docker-builder?style=flat-square)](https://hub.docker.com/r/gesquive/docker-builder)

Docker build image for x86_64/amd64 that can build multi-arch docker images.

Architectures supported include:
 - amd64
 - i386
 - armv6/v7
 - arm64

Includes the following build tools:

 - [qemu](https://www.qemu.org/)
 - [docker](https://docs.docker.com/install/)
 - [docker-buildkit](https://docs.docker.com/buildx/working-with-buildx/)

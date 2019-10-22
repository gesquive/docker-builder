FROM ubuntu:19.04

ENV DOCKER_CLI_EXPERIMENTAL=enabled

# Install build utils
RUN apt update && apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Install qemu
RUN apt install -y binfmt-support qemu-user-static

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt install -y docker-ce-cli

# Install buildx plugin
RUN mkdir -p ~/.docker/cli-plugins && \
    ARCH=`dpkg --print-architecture` && echo Installing for $ARCH && curl -s https://api.github.com/repos/docker/buildx/releases/latest | \
    grep "browser_download_url.*linux-$ARCH" | cut -d '"' -f4 | \
    xargs curl -L -o ~/.docker/cli-plugins/docker-buildx && \
    chmod a+x ~/.docker/cli-plugins/docker-buildx

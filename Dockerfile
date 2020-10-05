ARG BASE_IMAGE=ubuntu:20.04
FROM $BASE_IMAGE

ENV DOCKER_CLI_EXPERIMENTAL=enabled

# Install qemu, binfmt-support, and build utils
RUN apt-get update && apt-get install -y qemu-user-static binfmt-support make git curl && \
    rm -rf /var/lib/apt/lists/*

# Configure binfmt-support
RUN update-binfmts --enable && \
    curl https://raw.githubusercontent.com/qemu/qemu/master/scripts/qemu-binfmt-conf.sh -o /qemu-binfmt-conf.sh && \
    chmod +x /qemu-binfmt-conf.sh && \
    curl https://raw.githubusercontent.com/multiarch/qemu-user-static/master/containers/latest/register.sh -o /usr/bin/qemu-register.sh && \ 
    chmod +x /usr/bin/qemu-register.sh

# Install Docker
RUN export DEBIAN_FRONTEND=noninteractive && \
    export TZ=UTC &&\
    apt-get update && apt-get install -y --no-install-recommends apt-transport-https ca-certificates gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get install -y docker-ce-cli && \
    apt-get remove -y --purge apt-transport-https gnupg2 software-properties-common && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/* && \
    unset DEBIAN_FRONTEND && \
    unset TZ

# Install buildx plugin
RUN mkdir -p ~/.docker/cli-plugins && \
    ARCH=`dpkg --print-architecture` && echo "Installing for $ARCH" && \
    curl -s https://api.github.com/repos/docker/buildx/releases/latest | \
    grep "browser_download_url.*linux-$ARCH" | cut -d '"' -f4 | xargs curl -L -o ~/.docker/cli-plugins/docker-buildx && \
    chmod a+x ~/.docker/cli-plugins/docker-buildx

# Install spokeo
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 && \
    . /etc/os-release && \
    sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/x${NAME}_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list" && \
    curl -fsSL https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/x${NAME}_${VERSION_ID}/Release.key | apt-key add - && \
    apt-get update && apt-get install -y skopeo && \
    apt-get remove -y --purge gnupg2 && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/*

# Install cci-clone
RUN curl -sL https://git.io/JvVAE | bash

FROM ubuntu:19.04

ENV DOCKER_CLI_EXPERIMENTAL=enabled

# Install qemu, binfmt-support, and build utils
RUN apt update && apt install -y qemu-user-static binfmt-support make git curl && \
    rm -rf /var/lib/apt/lists/*

# Configure binfmt-support
RUN update-binfmts --enable && \
    curl https://raw.githubusercontent.com/qemu/qemu/master/scripts/qemu-binfmt-conf.sh -o /qemu-binfmt-conf.sh && \
    chmod +x /qemu-binfmt-conf.sh && \
    curl https://raw.githubusercontent.com/multiarch/qemu-user-static/master/containers/latest/register.sh -o /usr/bin/qemu-register.sh && \ 
    chmod +x /usr/bin/qemu-register.sh

# Install Docker
RUN apt update && apt install -y --no-install-recommends apt-transport-https ca-certificates gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt install -y docker-ce-cli && \
    apt remove -y --purge apt-transport-https gnupg2 software-properties-common && \
    apt autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/*

# Install buildx plugin
RUN mkdir -p ~/.docker/cli-plugins && \
    ARCH=`dpkg --print-architecture` && echo "Installing for $ARCH" && \
    curl -s https://api.github.com/repos/docker/buildx/releases/latest | \
    grep "browser_download_url.*linux-$ARCH" | cut -d '"' -f4 | xargs curl -L -o ~/.docker/cli-plugins/docker-buildx && \
    chmod a+x ~/.docker/cli-plugins/docker-buildx

# Install cci-clone
RUN curl -sL https://git.io/JvVAE | bash

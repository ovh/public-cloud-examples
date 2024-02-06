FROM ubuntu:latest
ARG PYTHON_VERSION=3.10

RUN apt-get update && apt-get install -yq \
    git \
    git-lfs \
    sudo \
    python${PYTHON_VERSION} \
    python3-venv \
    python3-pip \
    unzip \
    curl \
    docker.io \
    libgl1 \
    libglib2.0-0 \
    jq
    
# thoses steps reduce the size of the image but users nees to do apt update to install anything
#    docker.io \
#    && apt-get clean \
#    && rm -rf /var/cache/debconf/* /var/lib/apt/lists/* /tmp/* /var/tmp/* \
#    && apt-get clean -y
RUN curl https://cli.gra.ai.cloud.ovh.net/install.sh | bash
RUN cp /root/bin/ovhai /usr/local/bin/

# Create the gitpod user. UID must be 33333.
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod

USER gitpod

ENV VIRTUAL_ENV=/home/gitpod/venv
RUN python${PYTHON_VERSION} -m venv $VIRTUAL_ENV
#RUN cd /home/gitpod && curl -sS "$ARCHIVE_URL" -o "$ARCHIVE" && mkdir -p /home/gitpod/bin && unzip -q "$ARCHIVE" -d /home/gitpod/bin && chmod +x "/home/gitpod/bin/ovhai"



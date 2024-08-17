# The base image for all stages
ARG BASE_IMAGE=ubuntu:24.04

# Use a dedicated stage for downloading required dependencies
FROM ${BASE_IMAGE} as downloader

# These require BuildKit to be enabled
ARG BUILDOS
ARG BUILDARCH

# Pull in package list for downloader stage
COPY apt-downloader.txt /tmp/apt-downloader.txt

# Install required packages
RUN apt update && xargs -a /tmp/apt-downloader.txt apt install -y && \
    apt autoclean && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Grab Hugo at specified version
ARG HUGO_VERSION=0.128.2
RUN cd /tmp && \
    curl --fail -sL \
    https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_${BUILDOS}-${BUILDARCH}.tar.gz \
        | tar -xzf - hugo

# Grab Dart Sass at specified version
ARG DART_SASS_VERSION=1.77.8
RUN cd /tmp && \
    curl --fail -sL https://github.com/sass/dart-sass/releases/download/${DART_SASS_VERSION}/dart-sass-${DART_SASS_VERSION}-${BUILDOS}-$(dpkg --print-architecture).tar.gz \
        | tar -xzf -

# Grab Go at specified version
ARG GO_VERSION=1.22.5
RUN cd /tmp && \
    curl --fail -sL https://go.dev/dl/go${GO_VERSION}.${BUILDOS}-$(dpkg --print-architecture).tar.gz | tar -xzf - go

# This is the final stage
FROM ${BASE_IMAGE} as final

# Steal Hugo from the downloader stage
COPY --from=downloader /tmp/hugo /usr/local/bin/hugo

# Configure completion for Hugo
RUN mkdir -p /etc/bash_completion.d && \
    hugo completion bash > /etc/bash_completion.d/hugo

# Steal Dart Sass from the downloader stage and set PATH
COPY --from=downloader /tmp/dart-sass /usr/local/dart-sass/
ENV PATH="${PATH}:/usr/local/dart-sass"

# Steal Go from the downloader stage and set PATH
COPY --from=downloader /tmp/go /usr/local
ENV PATH="${PATH}:/usr/local/go/bin"

# Pull in package list
COPY apt-final.txt /tmp/apt-final.txt

# Install required packages
RUN apt update && xargs -a /tmp/apt-final.txt apt install -y && \
    apt autoclean && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# This volume is expected to be mounted when running the container
VOLUME [ "/host" ]

# Set the workdir to the volume for convenience
WORKDIR /host

EXPOSE 1313
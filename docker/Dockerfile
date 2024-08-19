# The base image for all stages
ARG BASE_IMAGE=alpine:3.20.2

# Use a dedicated stage for downloading required dependencies
FROM ${BASE_IMAGE} as downloader

# These require BuildKit to be enabled
ARG BUILDOS
ARG BUILDARCH

# Install packages required for downloader
RUN apk add --no-cache curl tar

# Grab Hugo at specified version
ARG HUGO_VERSION=0.128.2
RUN cd /tmp && \
    curl --fail -sL \
    https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_${BUILDOS}-${BUILDARCH}.tar.gz \
        | tar -xzf - hugo

# Grab Dart Sass at specified version
ARG DART_SASS_VERSION=1.77.8
RUN cd /tmp && \
    if [[ ${BUILDARCH} == "amd64" ]]; then export arch=x64; else export arch=${BUILDARCH}; fi && \
    curl --fail -sL https://github.com/sass/dart-sass/releases/download/${DART_SASS_VERSION}/dart-sass-${DART_SASS_VERSION}-${BUILDOS}-$arch.tar.gz \
        | tar -xzf -

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

# Install required packages
RUN apk add --no-cache bash bash-completion exiv2 git

# This volume is expected to be mounted when running the container
VOLUME [ "/host" ]

# Set the workdir to the volume for convenience
WORKDIR /host

# Expose port for hugo
EXPOSE 1313

# Default command of bash because sh is annoying
CMD [ "/bin/bash" ]

# Use the LinuxServer.io Debian baseimage
FROM ghcr.io/linuxserver/baseimage-debian:bullseye

# Allow override of PUID/PGID and timezone (Unraid-friendly)
ARG PUID=99
ARG PGID=100
ARG TZ=Etc/UTC
ENV PUID=${PUID} \
    PGID=${PGID} \
    TZ=${TZ}

# Install build tools and development headers for HEIC, JPEG, ICC, PNG, TIFF, XML
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       ca-certificates \
       curl \
       libheif-dev \
       libjpeg-turbo8-dev \
       liblcms2-dev \
       libpng-dev \
       libtiff-dev \
       libxml2-dev \
       pkg-config \
       git \
       wget \
    && rm -rf /var/lib/apt/lists/*

# Switch to non-root 'abc' user provided by LSIO baseimage
USER abc

# Working directory for source builds and conversions
WORKDIR /config

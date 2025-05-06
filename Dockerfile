# -----------------------------------------------------------------------------
# Image: cptchaz/imagemagick-container
# -----------------------------------------------------------------------------

# Use the LinuxServer baseimage (Debian Bullseye + s6 overlay)
FROM ghcr.io/linuxserver/baseimage-debian:bullseye

LABEL maintainer="Cpt. Chaz <cptchaz5408@gmail.com>"

# Install the build tools we need
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Build libheif (HEIC/AVIF support)
ENV LIBHEIF_VERSION=1.14.0
RUN wget -qO- "https://github.com/strukturag/libheif/releases/download/v${LIBHEIF_VERSION}/libheif-${LIBHEIF_VERSION}.tar.gz" \
    | tar xz \
 && cd libheif-${LIBHEIF_VERSION} \
 && ./configure --prefix=/usr/local \
 && make -j"$(nproc)" \
 && make install \
 && cd .. \
 && rm -rf libheif-${LIBHEIF_VERSION}

# Build ImageMagick itself
ENV IMAGEMAGICK_VERSION=7.1.1-47
RUN wget -qO- "https://download.imagemagick.org/ImageMagick/download/releases/ImageMagick-${IMAGEMAGICK_VERSION}.tar.gz" \
    | tar xz \
 && cd ImageMagick-${IMAGEMAGICK_VERSION} \
 && ./configure --prefix=/usr/local \
    --with-heic=yes \
 && make -j"$(nproc)" \
 && make install \
 && cd .. \
 && rm -rf ImageMagick-${IMAGEMAGICK_VERSION}

# Switch to the config directory at runtime
WORKDIR /config

# -----------------------------------------------------------------------------
# Image: cptchaz/imagemagick-container
# -----------------------------------------------------------------------------

# Dockerfile
FROM ghcr.io/linuxserver/baseimage-debian:bullseye

LABEL maintainer="Cpt. Chaz <cptchaz5408@gmail.com>" \
      org.opencontainers.image.version="7.1.1-47" \
      org.opencontainers.image.description="ImageMagick with HEIC/AVIF support on a Debian+s6 base"

# make builds noninteractive
ENV DEBIAN_FRONTEND=noninteractive
ENV LIBHEIF_VERSION=1.14.0
ENV IM_VERSION=7.1.1-47

# install build tools and runtime deps
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    wget \
    file \
  && rm -rf /var/lib/apt/lists/*

# build libheif for HEIC/AVIF support
RUN wget -qO- "https://github.com/strukturag/libheif/releases/download/v${LIBHEIF_VERSION}/libheif-${LIBHEIF_VERSION}.tar.gz" \
    | tar xz \
  && cd libheif-${LIBHEIF_VERSION} \
  && ./configure --prefix=/usr/local \
  && make -j"$(nproc)" \
  && make install \
  && cd .. \
  && rm -rf libheif-${LIBHEIF_VERSION}

# build ImageMagick from source with delegates
RUN wget -qO- "https://download.imagemagick.org/ImageMagick/download/releases/ImageMagick-${IM_VERSION}.tar.gz" \
    | tar xz \
  && cd ImageMagick-${IM_VERSION} \
  && ./configure \
        --prefix=/usr/local \
        --with-heic=yes \
  && make -j"$(nproc)" \
  && make install \
  && cd .. \
  && rm -rf ImageMagick-${IM_VERSION}

# drop back to config dir expected by linuxserver.io s6
WORKDIR /config

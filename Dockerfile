# -----------------------------------------------------------------------------
# Image: cptchaz/imagemagick-container
# -----------------------------------------------------------------------------

# Dockerfile
FROM ghcr.io/linuxserver/baseimage-debian:bullseye

LABEL maintainer="Cpt. Chaz <cptchaz5408@gmail.com>"
LABEL description="ImageMagick container with HEIF support"
LABEL version="7.1.1-47"

ENV DEBIAN_FRONTEND=noninteractive \
    LIBHEIF_VERSION=1.14.0 \
    IM_VERSION=7.1.1-47

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       build-essential \
       ca-certificates \
       wget \
       file \
  && rm -rf /var/lib/apt/lists/*

# Build and install libheif
RUN wget -qO- "https://github.com/strukturag/libheif/releases/download/v${LIBHEIF_VERSION}/libheif-${LIBHEIF_VERSION}.tar.gz" \
  | tar xz \
  && cd libheif-${LIBHEIF_VERSION} \
  && ./configure --prefix=/usr/local \
  && make -j"$(nproc)" \
  && make install \
  && cd .. \
  && rm -rf libheif-${LIBHEIF_VERSION}

# Build and install ImageMagick
RUN wget -qO- "https://download.imagemagick.org/ImageMagick/download/releases/ImageMagick-${IM_VERSION}.tar.gz" \
  | tar xz \
  && cd ImageMagick-${IM_VERSION} \
  && ./configure --prefix=/usr/local \
  && make -j"$(nproc)" \
  && make install \
  && cd .. \
  && rm -rf ImageMagick-${IM_VERSION}

# Ensure /usr/local/lib is on the dynamic loader path
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/local.conf \
  && ldconfig

WORKDIR /config

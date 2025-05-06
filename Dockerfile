# -----------------------------------------------------------------------------
# Image: cptchaz/imagemagick-container
# -----------------------------------------------------------------------------

# Dockerfile
FROM ghcr.io/linuxserver/baseimage-debian:bullseye

LABEL maintainer="Cpt. Chaz <cptchaz5408@gmail.com>"

# versions
ENV DEBIAN_FRONTEND=noninteractive \
    LIBHEIF_VERSION=1.14.0 \
    IM_VERSION=7.1.1-47

# install build tools + all delegate dev libs
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      wget \
      pkg-config \
      file \
      libjpeg-dev \
      libpng-dev \
      libtiff-dev \
      libxml2-dev \
      liblcms2-dev \
      liblzma-dev \
      libde265-dev \
      libdav1d-dev \
 && rm -rf /var/lib/apt/lists/*

# build and install libheif (HEIC/AVIF support)
RUN wget -qO- "https://github.com/strukturag/libheif/releases/download/v${LIBHEIF_VERSION}/libheif-${LIBHEIF_VERSION}.tar.gz" \
    | tar xz \
 && cd libheif-${LIBHEIF_VERSION} \
 && ./configure --prefix=/usr/local \
 && make -j"$(nproc)" \
 && make install \
 && cd .. \
 && rm -rf libheif-${LIBHEIF_VERSION}

# build and install ImageMagick (all delegates picked up)
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

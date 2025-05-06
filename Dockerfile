# Use the LinuxServer.io Debian baseimage
FROM ghcr.io/linuxserver/baseimage-debian:bullseye

# Allow override of PUID/PGID and timezone (Unraid-friendly)
ARG PUID=99
ARG PGID=100
ARG TZ=Etc/UTC
ENV PUID=${PUID} \
    PGID=${PGID} \
    TZ=${TZ}

# Install build tools and development headers for HEIC, JPEG, ICC, PNG, TIFF, XML and AV1/HEVC decoding
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       ca-certificates \
       curl \
       libheif-dev \
       libaom-dev \
       libde265-dev \
       libjpeg-dev \
       liblcms2-dev \
       libpng-dev \
       libtiff-dev \
       libxml2-dev \
       pkg-config \
       git \
       wget \
    && rm -rf /var/lib/apt/lists/*

#####################################
#  Build libheif from source       #
#####################################
ENV LIBHEIF_VERSION=1.14.0
RUN wget -qO- https://github.com/strukturag/libheif/releases/download/v${LIBHEIF_VERSION}/libheif-${LIBHEIF_VERSION}.tar.gz \
    | tar xz \
  && cd libheif-${LIBHEIF_VERSION} \
  && ./configure --prefix=/usr/local \
  && make -j"$(nproc)" \
  && make install \
  && cd .. \
  && rm -rf libheif-${LIBHEIF_VERSION}

#####################################
#  Build ImageMagick from source   #
#####################################
ENV IMAGEMAGICK_VERSION=7.1.1-47
RUN wget -qO- https://download.imagemagick.org/ImageMagick/download/releases/ImageMagick-${IMAGEMAGICK_VERSION}.tar.gz \
    | tar xz \
  && cd ImageMagick-${IMAGEMAGICK_VERSION} \
  && ./configure \
       --with-heic=yes \
       --with-jpeg=yes \
       --with-lcms=yes \
       --with-png=yes \
       --with-tiff=yes \
       --prefix=/usr/local \
  && make -j"$(nproc)" \
  && make install \
  && ldconfig \
  && cd .. \
  && rm -rf ImageMagick-${IMAGEMAGICK_VERSION}

# Switch to non-root 'abc' user for runtime and set working directory
USER abc
WORKDIR /config

# -----------------------------------------------------------------------------
# Image: cptchaz/imagemagick-container
# -----------------------------------------------------------------------------

# 1) Base image
FROM ghcr.io/linuxserver/baseimage-debian:bullseye

# 2) Build args & environment
ARG PUID=99
ARG PGID=100
ARG TZ=Etc/UTC
ENV PUID=${PUID} \
    PGID=${PGID} \
    TZ=${TZ}

# 3) Install compile‐time dependencies (incl. libheif from Debian)
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
       wget \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# 4) Build ImageMagick from source with HEIC, JPEG, PNG, TIFF, LCMS support
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
# 5) Switch to unprivileged user for runtime
# -----------------------------------------------------------------------------
USER abc
WORKDIR /config

# (No ENTRYPOINT/CMD here—will just run e.g. `magick` or whatever your wrapper does)

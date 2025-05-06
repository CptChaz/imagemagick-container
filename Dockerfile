# -----------------------------------------------------------------------------
# Image: cptchaz/imagemagick-container
# -----------------------------------------------------------------------------

#  syntax=docker/dockerfile:1
FROM ghcr.io/linuxserver/baseimage-debian:bullseye

# tell s6-init to leave the abc user at its default IDs (so it won't try to chown/chgrp)
ENV PUID=911 \
    PGID=911 \
    TZ=Etc/UTC \
    LIBHEIF_VERSION=1.14.0 \
    IM_VERSION=7.1.1-47

# install build dependencies (including system libheif so we don't have to hack around configure)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      wget \
      pkg-config \
      libjpeg-dev \
      libpng-dev \
      libtiff-dev \
      libde265-dev \
      libx265-dev \
      libxml2-dev \
      zlib1g-dev \
      libheif-dev \
 && rm -rf /var/lib/apt/lists/*

# download, configure, build & install ImageMagick
RUN wget -qO- https://download.imagemagick.org/ImageMagick/download/releases/ImageMagick-${IM_VERSION}.tar.gz \
      | tar xz \
 && cd ImageMagick-${IM_VERSION} \
 && ./configure --prefix=/usr/local \
 && make -j"$(nproc)" \
 && make install \
 && ldconfig \
 && cd .. \
 && rm -rf ImageMagick-${IM_VERSION}

WORKDIR /config

# leave the S6 /init entrypoint in place, and make 'magick' the default CMD
# so you can do `docker run --rm cptchaz/imagemagick-container:latest -version`
CMD ["magick"]

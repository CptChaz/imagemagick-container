# ImageMagick Container with HEIC/AVIF Support

A custom LinuxServer.io–based Docker image bundling ImageMagick 7 with HEIC/AVIF delegates (via libheif) on Debian Bullseye. Ideal for server-side image conversions using modern formats.

## Features

- **ImageMagick 7.1.x** built from source  
- **HEIC/AVIF** support via libheif  
- **OpenMP** acceleration when available  
- **LSIO** base image for robust init & user handling  
- Multi-architecture builds (x86_64, arm64, etc.)

## Quick Start

Pull and convert an image:

```bash
docker run --rm \
  -v "$(pwd)":/images \
  cptchaz/imagemagick-container:latest \
  magick input.heic output.jpg

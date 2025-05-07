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
```

Or use a specific released tag:
```
docker pull cptchaz/imagemagick-container:v1.0.0
```

## Build Locally
```
git clone https://github.com/cptchaz/imagemagick-container.git
cd imagmagick-container
docker build -t cptchaz/imagemagick-container:latest .
```
### Quick Start with Docker-Compose

If you prefer to manage your container with Docker-Compose (or Unraid’s Compose plugin), drop this into `docker-compose.yml`:

```
yaml
version: "3.8"
services:
  imagemagick:
    image: cptchaz/imagemagick-container:latest
    volumes:
      - /mnt/user/Media:/media
      - /mnt/user/appdata/imagemagick-container:/data
```
Then run:
```
docker-compose up -d
```
For Unrais:
Simply fill in those same two mappings in the container -> Volume Mappings fields

## Docker Hub: 
https://hub.docker.com/r/cptchaz/imagemagick-container

## Contributing:
1. Fork the repo
2. Create a feature branch
3. Submit a pull request against `main`

## License
MIT © 2025 Cpt. Chaz

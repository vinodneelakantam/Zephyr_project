FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        binutils-arm-none-eabi \
        ccache \
        cmake \
        device-tree-compiler \
        dfu-util \
        file \
        g++-multilib \
        gcc \
        gcc-arm-none-eabi \
        gcc-multilib \
        git \
        gperf \
        libmagic1 \
        libsdl2-dev \
        make \
        ninja-build \
        openocd \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        wget \
        xz-utils \
    && python3 -m pip install --no-cache-dir --break-system-packages --upgrade west \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
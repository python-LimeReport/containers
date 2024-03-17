#!/usr/bin/env bash

source "$HOME/.bashrc"

# check is x86

if [[ "$(uname -m)" == "x86_64" ]]; then
    aqt install-qt --outputdir /opt/Qt linux desktop ${QT_VERSION}
else
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        ninja-build \
        git \
        perl \
        libclang-dev \
        libfontconfig1-dev \
        libdbus-1-dev \
        libfreetype6-dev \
        libicu-dev \
        libinput-dev \
        libxkbcommon-dev \
        libxkbcommon-x11-dev \
        libsqlite3-dev \
        libssl-dev \
        libpng-dev \
        libjpeg-dev \
        libglib2.0-dev \
        libpulse-dev \
        libasound2-dev \
        libegl1-mesa-dev \
        libxcb1-dev \
        libx11-dev \
        libx11-xcb-dev \
        libxext-dev \
        libxfixes-dev \
        libxi-dev \
        libxrender-dev \
        libxcb-cursor-dev \
        libxcb-glx0-dev \
        libxcb-keysyms1-dev \
        libxcb-image0-dev \
        libxcb-shm0-dev \
        libxcb-icccm4-dev \
        libxcb-sync-dev \
        libxcb-xfixes0-dev \
        libxcb-shape0-dev \
        libxcb-randr0-dev \
        libxcb-render-util0-dev \
        libxcb-util-dev \
        libxcb-xinerama0-dev \
        libxcb-xkb-dev \
        libdrm-dev \
        libwayland-dev \
        libxcomposite-dev \
        libxcursor-dev \
        libxdamage-dev \
        libxrandr-dev \
        libxtst-dev \
        libxss-dev \
        libglu1-mesa-dev \
        mesa-common-dev \
        libgl1-mesa-dev \
        libgles2-mesa-dev \
        libgl1-mesa-dri \
        libgl-dev \
        libegl-dev \
        p7zip-full \
    && rm -rf /var/lib/apt/lists/*

    aqt install-src --outputdir /opt/Qt linux desktop ${QT_VERSION}

    cd /opt/Qt/${QT_VERSION}/Src
    ./configure -release -opensource -confirm-license -skip qtwebengine
    cmake --build . --parallel $(nproc)
    cmake --install .
fi 
# else if arm build from sources


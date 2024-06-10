#!/usr/bin/env bash

source "$HOME/.bashrc"

# check is x86

if [[ "$(uname -m)" == "x86_64" ]]; then
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        p7zip-full \
    && rm -rf /var/lib/apt/lists/*
    aqt install-qt --outputdir /opt/Qt linux desktop ${QT_VERSION}
    cd /opt/Qt/${QT_VERSION}
    mv gcc_64/* .
    mv gcc_64/.* .
    rmdir gcc_64
else
    # aqt -c /aqt.cfg install-src --outputdir /opt/Qt-src linux desktop ${QT_VERSION}

    cd /opt/Qt-src/${QT_VERSION}/Src
    /qt-patches/apply-patches.sh

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
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer-plugins-good1.0-dev \
        libgstreamer-plugins-bad1.0-dev \
        libavcodec-dev \
        libavformat-dev \
        libavdevice-dev \
        libavutil-dev \
        libavfilter-dev \
        libswscale-dev \
        libpostproc-dev \
        libswresample-dev \
        libva-dev \
        libva-drm2 \
        zstd \
        libpcre2-dev \
        libdouble-conversion-dev \
        libsystemd-dev \
        libbrotli-dev \
        libproxy-dev \
        libgssapi-krb5-2 \
        libatspi2.0-dev \
        libgbm-dev \
        libharfbuzz-dev \
        libmd4c-dev \
        libxcb1-dev \
        libgtk-3-dev \
        libcups2-dev \
        default-libmysqlclient-dev \
        libpq-dev \
        libodbc1 \
        firebird-dev \
        lttng-tools \
        libassimp-dev \
        libvulkan-dev \
        libpcsclite-dev \
        libhunspell-dev \
    && rm -rf /var/lib/apt/lists/*

    mkdir -p /opt/Qt/${QT_VERSION}
    cd /opt/Qt-src/${QT_VERSION}/Src
    ./configure -release -opensource -confirm-license -skip qtwebengine -prefix /opt/Qt/${QT_VERSION}
    # make -j$(nproc)
    cmake --build . --parallel $(nproc) || exit 1
    cmake --install . || exit 1
    rm -rf /opt/Qt-src
fi


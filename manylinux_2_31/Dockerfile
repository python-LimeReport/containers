FROM ubuntu:20.04 as env

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        zlib1g-dev \
        libncurses5-dev \
        libgdbm-dev \
        libnss3-dev \
        libssl-dev \
        libreadline-dev \
        libffi-dev \
        curl \
        software-properties-common \
        git \
        liblzma-dev \
        libbz2-dev \
    && rm -rf /var/lib/apt/lists/*

ARG PYTHON_VERSION=3.9
COPY ./scripts/install_python.sh /
RUN /install_python.sh && rm -f /install_python.sh

ARG AQTINSTALL_VERSION=3.1.15
RUN python3 -m pip install aqtinstall==${AQTINSTALL_VERSION}

ENV PATH=/root/.local/bin:$PATH

ARG QT_VERSION=6.4.2
ENV QT_VERSION=${QT_VERSION}

COPY ./scripts/install_qt.sh ./aqt.cfg /
RUN aqt -c /aqt.cfg install-src --outputdir /opt/Qt-src linux ${QT_VERSION}
COPY ./qt-patches/ /qt-patches
RUN cd /opt/Qt-src/${QT_VERSION}/Src && /qt-patches/apply-patches.sh

RUN apt-get update && \
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

RUN mkdir -p /opt/Qt/${QT_VERSION} \
&& cd /opt/Qt-src/${QT_VERSION}/Src \
&& ./configure -release -opensource -confirm-license -skip qtwebengine -prefix /opt/Qt/${QT_VERSION} \
&& make -j$(nproc)

RUN cmake --build . --parallel $(nproc) || exit 1
RUN cmake --install . || exit 1

# TODO
# 1. fixes "test -x /opt/python/cp39-cp39/bin/python"
# 2. fixes UTILITY_PYTHON = "/opt/python/cp38-cp38/bin/python"
RUN mkdir /opt/python \
    && ln -s /usr/local /opt/python/cp39-cp39 \
    && ln -s /usr/local /opt/python/cp38-cp38 \
    && ln -s /usr/local/bin/python3 /usr/local/bin/python \
    && ln -s /usr/local/bin/pip3 /usr/local/bin/pip

ENV PATH="/opt/Qt/${QT_VERSION}/bin:$PATH"
ENV LD_LIBRARY_PATH="/opt/Qt/${QT_VERSION}/lib"
ENV PYTHON_VERSION=${PYTHON_VERSION}
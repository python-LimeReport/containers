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

COPY ./qt-patches/ /qt-patches
COPY ./scripts/install_qt.sh ./aqt.cfg /
# RUN aqt -c /aqt.cfg install-src --outputdir /opt/Qt-src linux ${QT_VERSION}

# RUN cd /opt/Qt-src/${QT_VERSION}/Src && /qt-patches/apply-patches.sh

RUN /install_qt.sh && rm -f /install_qt.sh

# TODO
# 1. fixes "test -x /opt/python/cp39-cp39/bin/python"
# 2. fixes UTILITY_PYTHON = "/opt/python/cp38-cp38/bin/python"
RUN mkdir /opt/python \
    && ln -s /usr/local /opt/python/cp39-cp39 \
    && ln -s /usr/local /opt/python/cp38-cp38 \
    && ln -s /usr/local/bin/python3 /usr/local/bin/python \
    && ln -s /usr/local/bin/pip3 /usr/local/bin/pip

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libxslt1.1 \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/opt/Qt/${QT_VERSION}/bin:$PATH"
ENV LD_LIBRARY_PATH="/opt/Qt/${QT_VERSION}/lib"
ENV PYTHON_VERSION=${PYTHON_VERSION}
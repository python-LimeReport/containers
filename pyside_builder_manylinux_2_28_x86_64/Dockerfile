FROM amd64/almalinux:8 as env

RUN yum -y update \
    && yum -y groupinstall 'Development Tools' \
    && yum -y install \
        wget \
        openssl-devel \
        bzip2-devel \
        libffi-devel \
        cmake \
        clang \
        clang-devel \
        llvm \
        llvm-devel \
        mesa-libGL-devel \
        pulseaudio-libs-glib2 \
    && dnf --enablerepo=powertools -y install ninja-build \
    && yum clean all \
    && rm -rf /var/cache/yum

COPY ./scripts/install_python.sh /
ARG PYTHON_VERSION=3.9
RUN /install_python.sh && rm -f /install_python.sh
COPY ./scripts/install_pipx.sh /
RUN /install_pipx.sh && rm -f /install_pipx.sh
ARG AQTINSTALL_VERSION=3.1.7
RUN pipx install aqtinstall==${AQTINSTALL_VERSION}
ENV PATH=/root/.local/bin:$PATH
ARG QT_VERSION=6.4.2
COPY ./scripts/install_qt.sh /
RUN /install_qt.sh && rm -f /install_qt.sh

ENV PATH="/opt/Qt/${QT_VERSION}/gcc_64/bin:$PATH"
ENV QT_VERSION=${QT_VERSION}
ENV PYTHON_VERSION=${PYTHON_VERSION}
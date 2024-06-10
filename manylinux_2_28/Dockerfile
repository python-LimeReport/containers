ARG BUILD_TARGET=x86_64

FROM quay.io/pypa/manylinux_2_28_${BUILD_TARGET} as env

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
        libxkbcommon \
    && yum clean all \
    && rm -rf /var/cache/yum

ARG AQTINSTALL_VERSION=3.1.15
ARG QT_VERSION=6.4.2

RUN pipx install aqtinstall==${AQTINSTALL_VERSION} \
    && aqt install-qt --outputdir /opt/Qt linux desktop ${QT_VERSION} \
    && find /opt/Qt/${QT_VERSION}/gcc_64 -mindepth 1 -maxdepth 1 ! -name '.' ! -name '..' -exec mv {} /opt/Qt/${QT_VERSION}/ \; \
    && rmdir /opt/Qt/${QT_VERSION}/gcc_64 || true

ENV PATH="/opt/Qt/${QT_VERSION}/bin:$PATH"
ENV QT_VERSION=${QT_VERSION}
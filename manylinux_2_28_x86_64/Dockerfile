FROM quay.io/pypa/manylinux_2_28_x86_64 as env

ARG AQTINSTALL_VERSION=3.1.6
ARG QT_VERSION=6.4.2

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
    && dnf --enablerepo=powertools -y install ninja-build \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN pipx install aqtinstall==${AQTINSTALL_VERSION} \
    && aqt install-qt --outputdir /opt/Qt linux desktop ${QT_VERSION}

ENV PATH="/opt/Qt/${QT_VERSION}/gcc_64/bin:$PATH"
ENV QT_VERSION=${QT_VERSION}
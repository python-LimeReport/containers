FROM amd64/almalinux:8 as env

ARG AQTINSTALL_VERSION=3.1.6
ARG QT_VERSION=6.4.2
ARG PYTHON_VERSION=3.9

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

COPY ./scripts/install_python.sh ./scripts/install_pipx.sh ./scripts/install_qt.sh /
RUN /install_python.sh && rm -f /install_python.sh
RUN /install_pipx.sh && rm -f /install_pipx.sh
RUN pipx install aqtinstall==${AQTINSTALL_VERSION}
RUN /install_qt.sh && rm -f /install_qt.sh

ENV PATH="/opt/Qt/${QT_VERSION}/gcc_64/bin:$PATH"

RUN cd /opt \
   && git clone -b ${QT_VERSION} https://code.qt.io/pyside/pyside-setup.git \
   && cd pyside-setup \
   && pip3 install -r requirements.txt \
   && python3 setup.py build --parallel "$(nproc)" --limited-api yes \
   && mkdir -p /output \
   && export dir_name=qfpa-py${PYTHON_VERSION}-qt${QT_VERSION}-64bit-release \
   && tar czvf "/output/$dir_name.tar.gz" -C "./build/$dir_name/install" .

RUN cd /opt/pyside-setup \
   && python3 setup.py build --parallel "$(nproc)" bdist_wheel --limited-api yes

RUN cp /opt/pyside-setup/dist/* /output
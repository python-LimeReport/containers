FROM ubuntu:20.04 as env

ARG PYTHON_VERSION=3.9
ARG AQTINSTALL_VERSION=3.1.6
ARG QT_VERSION=6.4.2

COPY ./scripts/install_python.sh ./scripts/install_pipx.sh ./scripts/install_qt.sh /

RUN /install_python.sh && rm -f /install_python.sh
RUN /install_pipx.sh && rm -f /install_pipx.sh
RUN pipx install aqtinstall==${AQTINSTALL_VERSION}

ENV PATH=/root/.local/bin:$PATH

RUN /install_qt.sh && rm -f /install_qt.sh

ENV PATH="/opt/Qt/${QT_VERSION}/gcc_64/bin:$PATH"
ENV LD_LIBRARY_PATH="/opt/Qt/${{ matrix.qt }}/gcc_64/lib"
ENV QT_VERSION=${QT_VERSION}
ENV PYTHON_VERSION=${PYTHON_VERSION}
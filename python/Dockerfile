ARG OPENSSL_VERSION
FROM yurkao/openssl:${OPENSSL_VERSION} as staging

ENV INSTALL_DIR="/usr/local/python3"
ENV LD_LIBRARY_PATH="${INSTALL_DIR}/lib:$LD_LIBRARY_PATH"
ENV PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/sbin:$PATH"

ENV PYTHON_VERSION=3.9.6
ENV GPG_KEY=E3FF2839C048B25C084DEBE9B26995E310250568
# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION=21.2.4
# https://github.com/pypa/get-pip
ENV PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/c20b0cfd643cd4a19246ccf204e2997af70f6b21/public/get-pip.py
ENV PYTHON_GET_PIP_SHA256=fa6f3fb93cce234cd4e8dd2beb54a51ab9c247653b52855a48dd44e6b21ff28b
ENV LANG=C.UTF-8


ENV BUILD_DEPS="make wget perl build-essential quilt ca-certificates"
ENV BUILD_DEPS="${BUILD_DEPS} zlib1g-dev libexpat1-dev libffi-dev libbz2-dev liblzma-dev libreadline-dev"
ENV BUILD_DEPS="${BUILD_DEPS} uuid-dev libncurses5-dev libsqlite3-dev"
# avoid test_asyncio Servname not supported for ai_socktype exception
ENV BUILD_DEPS="${BUILD_DEPS} netbase"
ENV PYTHON_PATCH_DIR="/python.patches"

USER root
ADD patches-"${PYTHON_VERSION}"/* "${PYTHON_PATCH_DIR}"/
ADD build-python.sh /sbin
RUN sh -e /sbin/build-python.sh
ADD tests ${TEST_DIR}/
RUN chmod a+rx "${TEST_DIR}"/*.sh
USER nobody
RUN run-tests

FROM ubuntu:focal
ENV TEST_DIR=/tests
ENV LANG=C.UTF-8
ENV PYTHON_DIR="/usr/local/python3"
ENV OPENSSL_DIR="/usr/local/openssl"
ENV PATH="${PYTHON_DIR}/bin:${OPENSSL_DIR}/bin:$PATH"
ENV OPENSSL_CONF="${OPENSSL_DIR}"/openssl.cnf

COPY --from=staging  /etc/ld.so.conf.d /etc/ld.so.conf.d
COPY --from=staging "${OPENSSL_DIR}" "${OPENSSL_DIR}"

COPY --from=staging "${PYTHON_DIR}"/bin "${PYTHON_DIR}"/bin
COPY --from=staging "${PYTHON_DIR}"/lib "${PYTHON_DIR}"/lib
COPY --from=staging "${TEST_DIR}" "${TEST_DIR}"
COPY --from=staging "/sbin/run-tests" /sbin

RUN ldconfig
USER nobody
RUN run-tests

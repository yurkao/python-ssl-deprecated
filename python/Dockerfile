ARG OPENSSL_VERSION
FROM yurkao/openssl:${OPENSSL_VERSION}
#FROM ubuntu:focal
#ENV OPENSSL_DIR=/usr
#ENV TEST_DIR=/tests
#ENV CACHE_UPDATE="apt update -qq"
#ENV PKG_ADD='apt install -y -qq'
#ENV PKG_DEL="apt autoremove -y --purge"
#ENV CLEAR_CACHE="apt-get clean"


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

#ENV INSTALL_DEPS="zlib1g libexpat1 libffi7 libbz2-1.0 liblzma5 libreadline5"
#ENV INSTALL_DEPS="${INSTALL_DEPS} uuid tzdata libncurses5 libsqlite3-0"

ENV BUILD_DEPS="make wget perl build-essential quilt ca-certificates"
ENV BUILD_DEPS="${BUILD_DEPS} zlib1g-dev libexpat1-dev libffi-dev libbz2-dev liblzma-dev libreadline-dev"
ENV BUILD_DEPS="${BUILD_DEPS} uuid-dev libncurses5-dev libsqlite3-dev"
# avoid test_asyncio Servname not supported for ai_socktype exception
#ENV BUILD_DEPS="${BUILD_DEPS} netbase libssl-dev"
ENV PYTHON_PATCH_DIR="/python.patches"

USER root
ADD patches-"${PYTHON_VERSION}"/* "${PYTHON_PATCH_DIR}"/
ADD build-python.sh /sbin
#RUN ${CACHE_UPDATE} && ${PKG_ADD} ${INSTALL_DEPS} > /dev/null
RUN sh -e /sbin/build-python.sh && rm -rf "${PYTHON_PATCH_DIR}"

ADD tests ${TEST_DIR}/
RUN chmod a+rx "${TEST_DIR}"/*.sh
USER nobody
#RUN run-tests

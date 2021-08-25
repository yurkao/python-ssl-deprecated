FROM yurkao/openssl:1.0.2u
ENV PYTHON_VERSION=3.9.6
ENV GPG_KEY=E3FF2839C048B25C084DEBE9B26995E310250568
# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION=21.2.4
# https://github.com/pypa/get-pip
ENV PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/c20b0cfd643cd4a19246ccf204e2997af70f6b21/public/get-pip.py
ENV PYTHON_GET_PIP_SHA256=fa6f3fb93cce234cd4e8dd2beb54a51ab9c247653b52855a48dd44e6b21ff28b
ENV LANG=C.UTF-8

ENV BUILD_DEPS="build-essential gdb lcov libbz2-dev libexpat1-dev libffi-dev libgdbm-dev liblz-dev"
ENV BUILD_DEPS="${BUILD_DEPS} liblzma-dev libncurses5-dev libreadline6-dev libsqlite3-dev "
ENV BUILD_DEPS="${BUILD_DEPS} lzma lzma-dev make tk-dev uuid-dev wget zlib1g-dev"
ENV BUILD_DEPS="${BUILD_DEPS} quilt"
ENV PYTHON_PATCH_DIR="/python.patches"

ADD patches-"${PYTHON_VERSION}"/* "${PYTHON_PATCH_DIR}"/
ADD build-python.sh /sbin
RUN sh -e /sbin/build-python.sh

ADD tests ${TEST_DIR}/
RUN run-tests

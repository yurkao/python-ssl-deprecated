FROM yurkao/openssl:1.0.2k
ENV PYTHON_VERSION=3.9.6
ENV GPG_KEY=E3FF2839C048B25C084DEBE9B26995E310250568
# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION=21.2.4
# https://github.com/pypa/get-pip
ENV PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/c20b0cfd643cd4a19246ccf204e2997af70f6b21/public/get-pip.py
ENV PYTHON_GET_PIP_SHA256=fa6f3fb93cce234cd4e8dd2beb54a51ab9c247653b52855a48dd44e6b21ff28b
ENV LANG=C.UTF-8

ENV BUILD_DEPS="make wget build-essential libffi-dev zlib1g-dev libexpat1-dev libsqlite3-dev lzma-dev"
ENV TEST_DIR=/tests

ADD tests ${TEST_DIR}/
RUN chmod 644 "${TEST_DIR}"/* && chmod 755 "${TEST_DIR}"/*.sh
ADD build-python.sh /sbin
RUN sh -e /sbin/build-python.sh

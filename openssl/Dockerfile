FROM debian:stable-slim

ENV OPENSSL_DIR=/usr/local
ENV INSTALL_DIR="${OPENSSL_DIR}"
ENV TEST_SERVER="google.com:443"
ENV LD_LIBRARY_PATH="${INSTALL_DIR}/lib:${INSTALL_DIR}/lib64:$LD_LIBRARY_PATH"
ENV PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/sbin:$PATH"

ENV TEST_DIR=/tests
ENV CACHE_UPDATE="apt-get update -qq"
ENV PKG_ADD="apt-get install -y -qq -o=Dpkg::Use-Pty=0 "
ENV PKG_DEL="apt-get purge --auto-remove -y"
ENV CLEAR_CACHE="apt-get clean"
ENV BUILD_DEPS="make wget build-essential libffi-dev zlib1g-dev"
ENV TEST_DIR=/tests

ENV OPENSSL_VERSION="1.0.2u"

ADD tests ${TEST_DIR}/
RUN chmod 644 "${TEST_DIR}"/* && chmod 755 "${TEST_DIR}"/*.sh

ADD build-openssl.sh /sbin/
ADD run-tests /sbin/
RUN chmod 755 /sbin/run-tests && sh -e /sbin/build-openssl.sh
RUN ${CACHE_UPDATE} && $PKG_ADD ca-certificates && ${CLEAR_CACHE} && rm -rf /var/lib/apt/lists
RUN run-tests

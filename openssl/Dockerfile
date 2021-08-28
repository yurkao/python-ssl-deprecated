FROM debian:stable-slim

ENV OPENSSL_DIR=/usr/local/openssl
ENV INSTALL_DIR="${OPENSSL_DIR}"
ENV TEST_SERVER="google.com:443"
ENV LD_LIBRARY_PATH="${INSTALL_DIR}/lib:${INSTALL_DIR}/lib64:$LD_LIBRARY_PATH"
ENV PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/sbin:$PATH"
ENV SSL_CONF_DIR="${OPENSSL_DIR}"
ENV OPENSSL_PATCH_DIR="/openssl.patches"
ENV TEST_DIR=/tests
ENV CACHE_UPDATE="apt-get update -qq"
ENV PKG_ADD='apt install -y -qq'
ENV PKG_DEL="apt autoremove -y --purge"
ENV CLEAR_CACHE="apt-get clean"
ENV BUILD_DEPS="make wget build-essential libffi-dev zlib1g-dev bsdextrautils"
ENV BUILD_DEPS="${BUILD_DEPS} quilt"
ENV TEST_DIR=/tests
# ca-certificates are reuired for downloading and post-build testing
RUN ${CACHE_UPDATE} && ${PKG_ADD} ca-certificates

ARG OPENSSL_VERSION

ADD 02-no-recommends /etc/apt/apt.conf.d/

ENV QUILT_NO_DIFF_INDEX=1
ENV QUILT_NO_DIFF_TIMESTAMPS=1
ENV QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"
ENV QUILT_PATCH_OPTS="--reject-format=unified"

ADD run-tests /sbin/
ADD tests ${TEST_DIR}/
ADD build-openssl.sh /sbin/
ADD patches-"${OPENSSL_VERSION}"/* "${OPENSSL_PATCH_DIR}"/

RUN sh -e /sbin/build-openssl.sh

# set it here - do not intefer with build and build tests
ENV OPENSSL_CONF="${OPENSSL_DIR}"/openssl.cnf

RUN chmod 755 /sbin/run-tests && chmod 755 "${TEST_DIR}"/*.sh
USER nobody
RUN run-tests

FROM ubuntu:focal as staging

ENV OPENSSL_DIR=/usr/local/openssl
ENV INSTALL_DIR="${OPENSSL_DIR}"
#ENV LD_LIBRARY_PATH="${INSTALL_DIR}/lib:$LD_LIBRARY_PATH"
ENV PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/sbin:$PATH"
ENV SSL_CONF_DIR="${OPENSSL_DIR}"
ENV OPENSSL_PATCH_DIR="/openssl.patches"
ENV TEST_DIR=/tests
ENV CACHE_UPDATE="apt update -qq"
ENV PKG_ADD='apt install -y -qq'
ENV PKG_DEL="apt autoremove -y --purge"
ENV CLEAR_CACHE="apt-get clean && rm -rf /var/lib/apt/lists"
ENV BUILD_DEPS="make wget build-essential libffi-dev zlib1g-dev ca-certificates"
ENV BUILD_DEPS="${BUILD_DEPS} quilt"
ENV TEST_DIR=/tests

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

# run-time dependencies
RUN ${CACHE_UPDATE} && ${PKG_ADD} zlib1g && sh -e /sbin/build-openssl.sh && rm -rf "${OPENSSL_PATCH_DIR}" && chmod a+rx /sbin/run-tests
# set it here - do not intefer with build and build tests
USER nobody
RUN run-tests

FROM ubuntu:focal
ENV OPENSSL_DIR=/usr/local/openssl
ENV TEST_DIR=/tests
ENV PATH="${OPENSSL_DIR}/bin:$PATH"
ENV CACHE_UPDATE="apt update -qq"
ENV PKG_ADD='apt install -y -qq'
ENV PKG_DEL="apt autoremove -y --purge"
ENV CLEAR_CACHE="apt-get clean"
ADD 02-no-recommends /etc/apt/apt.conf.d/
ADD run-tests /sbin/
ADD tests ${TEST_DIR}/

USER root
COPY --from=staging "${OPENSSL_DIR}" "${OPENSSL_DIR}"
RUN echo "${OPENSSL_DIR}/lib" > /etc/ld.so.conf.d/openssl.conf && ldconfig
ENV OPENSSL_CONF="${OPENSSL_DIR}"/openssl.cnf

RUN chmod 755 /sbin/run-tests && chmod 755 "${TEST_DIR}"/*.sh

USER nobody
RUN run-tests

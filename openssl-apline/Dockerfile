FROM alpine:3.14 as staging

ENV OPENSSL_DIR=/usr/local/openssl
ENV INSTALL_DIR="${OPENSSL_DIR}"
#ENV LD_LIBRARY_PATH="${INSTALL_DIR}/lib:$LD_LIBRARY_PATH"
ENV PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/sbin:$PATH"
ENV SSL_CONF_DIR="${OPENSSL_DIR}"
ENV OPENSSL_PATCH_DIR="/openssl.patches"
ENV TEST_DIR=/tests
ENV CACHE_UPDATE="apk update"
ENV PKG_ADD='apk add --no-cache --virtual'
ENV PKG_DEL="apk del"
ENV BUILD_DEPS="libffi-dev zlib-dev ca-certificates quilt perl make makedepend libc-dev linux-headers gcc"
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
RUN  sh -ex /sbin/build-openssl.sh && chmod a+rx /sbin/run-tests
# set it here - do not intefer with build and build tests
USER nobody
RUN run-tests

FROM alpine:3.14
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
RUN ldconfig "${OPENSSL_DIR}/lib"
ENV OPENSSL_CONF="${OPENSSL_DIR}"/openssl.cnf

RUN chmod 755 /sbin/run-tests && chmod 755 "${TEST_DIR}"/*.sh

USER nobody
RUN run-tests

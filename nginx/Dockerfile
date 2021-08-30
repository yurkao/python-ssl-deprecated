ARG OPENSSL_VERSION
FROM yurkao/openssl:${OPENSSL_VERSION} as staging

ARG NGINX_VERSION="1.18.0"
ENV BUILD_DEPS="${BUILD_DEPS} libpcre3-dev wget ca-certificates build-essential zlib1g-dev"
ENV NGINX_DIR="/usr/local/nginx"
ENV PATH="${NGINX_DIR}/bin:${NGINX_DIR}/sbin:${PATH}"

USER root
ADD build-nginx.sh /sbin
RUN sh -e /sbin/build-nginx.sh


FROM ubuntu:focal
ENV TEST_DIR=/tests
ENV LANG=C.UTF-8
ENV NGINX_DIR="/usr/local/nginx"
ENV OPENSSL_DIR="/usr/local/openssl"
ENV PATH="${NGINX_DIR}/sbin:${OPENSSL_DIR}/bin:$PATH"
ENV OPENSSL_CONF="${OPENSSL_DIR}"/openssl.cnf
ENV NGINX_KEY=nginx.key
ENV NGINX_CRT=nginx.crt

COPY --from=staging  /etc/ld.so.conf.d /etc/ld.so.conf.d
COPY --from=staging "${OPENSSL_DIR}" "${OPENSSL_DIR}"
COPY --from=staging "${NGINX_DIR}" "${NGINX_DIR}"
COPY --from=staging "${TEST_DIR}" "${TEST_DIR}"
COPY --from=staging "/sbin/run-tests" /sbin
ADD nginx.conf "${NGINX_DIR}/conf/"
ADD patch-ciphers.sh start-nginx.sh  /sbin/
RUN chmod a+rx /sbin/patch-ciphers.sh /sbin/start-nginx.sh

RUN ldconfig
USER nobody
RUN run-tests
USER root
CMD nginx

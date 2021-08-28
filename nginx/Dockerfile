ARG OPENSSL_VERSION="1.0.2u-vuln"
FROM yurkao/openssl:1.0.2u-vuln

ARG NGINX_VERSION="1.18.0"
ENV BUILD_DEPS="${BUILD_DEPS} libpcre3-dev"
ENV NGINX_DIR="/usr/local/nginx"
ENV PATH="${NGINX_DIR}/bin:${NGINX_DIR}/sbin:${PATH}"
ENV NGINX_KEY=nginx.key
ENV NGINX_CRT=nginx.crt

USER root
ADD build-nginx.sh /sbin
RUN sh -e /sbin/build-nginx.sh
ADD nginx.conf "${NGINX_DIR}/conf/"
CMD nginx
ADD patch-ciphers.sh start-nginx.sh  /sbin/
RUN chmod a+rx /sbin/patch-ciphers.sh /sbin/start-nginx.sh

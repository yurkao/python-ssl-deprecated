FROM yurkao/openssl:1.0.2u

ENV NGINX_VERSION="1.18.0"
ENV BUILD_DEPS="${BUILD_DEPS} libpcre3-dev"
ENV NGINX_DIR="/usr/local/nginx"
ENV PATH="${NGINX_DIR}/bin:${NGINX_DIR}/sbin:${PATH}"
ENV NGINX_KEY=nginx.key
ENV NGINX_CRT=nginx.crt

ADD build-nginx.sh /sbin
RUN sh -e /sbin/build-nginx.sh
ADD nginx.conf "${NGINX_DIR}/conf/"
RUN yes AB | openssl req -x509 -newkey rsa:512 -keyout "${NGINX_DIR}/${NGINX_KEY}" -out "${NGINX_DIR}/${NGINX_CRT}" -days 365 -nodes > /dev/null
RUN sed -ri "s@ssl_certificate[ ]*/.+;@ssl_certificate ${NGINX_DIR}/${NGINX_CRT};@g" "${NGINX_DIR}/conf/nginx.conf"
RUN sed -ri "s@ssl_certificate_key[ ]*/.+;@ssl_certificate_key ${NGINX_DIR}/${NGINX_KEY};@g" "${NGINX_DIR}/conf/nginx.conf"
ADD tests ${TEST_DIR}/
RUN run-tests
CMD nginx

#!/usr/bin/env sh
cleanup() {
  cd /  # release BUILD_DIR
  rm -rf "${BUILD_DIR}"
  # shellcheck disable=SC2086
  ${PKG_DEL} ${BUILD_DEPS}  >/dev/null 2>/dev/null && ${CLEAR_CACHE} && rm -rf /var/lib/apt/lists
}

trap cleanup EXIT

${CACHE_UPDATE}

# shellcheck disable=SC2086
${PKG_ADD} ${BUILD_DEPS}  >/dev/null 2>/dev/null

BUILD_DIR="$(mktemp -d)"
cd "${BUILD_DIR}" || exit 1

wget --quiet  -O "${BUILD_DIR}/nginx.tar.gz" "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz"
tar zxf nginx.tar.gz
cd "nginx-${NGINX_VERSION}" || exit 1

BUILD_OPTS="--with-http_ssl_module --with-stream --with-debug --with-http_ssl_module --with-threads"

# shellcheck disable=SC2086
./configure ${BUILD_OPTS} --prefix="${NGINX_DIR}" --pid-path=/tmp/nginx.pid \
  --with-cc-opt="-I${OPENSSL_DIR}/include" --with-ld-opt="-L${OPENSSL_DIR}/lib"

CORES="$(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')"
MAKE="make -j${CORES}"
${MAKE}
${MAKE} install
find "${OPENSSL_DIR}" -type f -name '*.a' -print0 | xargs --no-run-if-empty -0 rm -f
rm -rf "${OPENSSL_DIR}/include"
find "${INSTALL_DIR}" -type f -name '*.a' -print0 | xargs --no-run-if-empty -0 rm -f

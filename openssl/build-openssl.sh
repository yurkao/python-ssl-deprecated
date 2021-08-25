#!/usr/bin/env sh

cleanup() {
  rm -rf "${BUILD_DIR}/openssl-${OPENSSL_VERSION}"* "${SSL_CONF_DIR}"/man "${INSTALL_DIR}"/share/man
  # shellcheck disable=SC2086
  ${PKG_DEL} ${BUILD_DEPS} && ${CLEAR_CACHE} && rm -rf /var/lib/apt/lists
}

trap cleanup EXIT

$CACHE_UPDATE
# shellcheck disable=SC2086
$PKG_ADD ${BUILD_DEPS}

export INSTALL_OPTS="--prefix=${INSTALL_DIR}/ --openssldir=${SSL_CONF_DIR}/"

BUILD_DIR="$(mktemp -d)"

# shellcheck disable=SC2086
mkdir -p "${BUILD_DIR}/openssl-${OPENSSL_VERSION}"
wget --quiet  -O "${BUILD_DIR}/openssl-${OPENSSL_VERSION}.tar.gz" "https://openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz"
# TODO[yo: check signature
tar zxf "${BUILD_DIR}/openssl-${OPENSSL_VERSION}.tar.gz" --strip-components=1 -C "${BUILD_DIR}/openssl-${OPENSSL_VERSION}"
cd "${BUILD_DIR}/openssl-${OPENSSL_VERSION}" || exit 1

XARGS="xargs --no-run-if-empty -t -0 -n 1"
find "${OPENSSL_PATCH_DIR}"/ -maxdepth 1 -type f -name '*.patch' -print0 | sort -z | ${XARGS} patch -p0 -i

export LD_FLAGS="-Wl,--enable-new-dtags,-rpath=${INSTALL_DIR}/lib"
export SSL_BUILD_OPTS="${INSTALL_OPTS} -DOPENSSL_USE_BUILD_DATE -Wl,--enable-new-dtags,-rpath=${INSTALL_DIR}/lib"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-zlib enable-ssl2 enable-ssl3"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-npn enable-psk enable-weak-ssl-ciphers enable-srp"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-ssl-trace enable-rc5 enable-rc2 enable-3des enable-des"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-cms enable-md2 enable-mdc2 enable-ec enable-ec2m enable-ecdh enable-ecdsa"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-seed enable-camellia enable-idea enable-rfc3779"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-dtls1 enable-threads"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-ec_nistp_64_gcc_128"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-aesgcm enable-aes-enable enable-dh enable-adh enable-edh enable-dhe"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-export enable-export40 enable-export56 enable-export1024 enable-srp enable-gost"

# shellcheck disable=SC2155
export MAKE="make"

${MAKE} clean
# shellcheck disable=SC2086
./config ${SSL_BUILD_OPTS} shared
${MAKE} depend
${MAKE}
${MAKE} test
${MAKE} install

ldconfig

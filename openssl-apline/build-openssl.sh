#!/usr/bin/env sh

. /tests/common

mkdir -p /etc/apk

echo 'https://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories

${CACHE_UPDATE}
${PKG_ADD} .fetch-deps tar gzip

# shellcheck disable=SC2086
${PKG_ADD} .build-deps ${BUILD_DEPS}

export INSTALL_OPTS="--prefix=${INSTALL_DIR}/ --openssldir=${SSL_CONF_DIR}/"

BUILD_DIR="$(mktemp -d)"

# shellcheck disable=SC2086
mkdir -p "${BUILD_DIR}/openssl-${OPENSSL_VERSION}"
wget --quiet  -O "${BUILD_DIR}/openssl-${OPENSSL_VERSION}.tar.gz" "https://openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz"
# TODO[yo: check signature
tar zxf "${BUILD_DIR}/openssl-${OPENSSL_VERSION}.tar.gz" --strip-components=1 -C "${BUILD_DIR}/openssl-${OPENSSL_VERSION}"
cd "${BUILD_DIR}/openssl-${OPENSSL_VERSION}" || exit 1

apply_patches "${OPENSSL_PATCH_DIR}"


export LD_FLAGS="-Wl,--enable-new-dtags,-rpath=${INSTALL_DIR}/lib -z -Wl,--strip-all"
export SSL_BUILD_OPTS="${INSTALL_OPTS} -DOPENSSL_USE_BUILD_DATE -Wl,--enable-new-dtags"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-zlib enable-ssl2 enable-ssl3"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-npn enable-psk enable-weak-ssl-ciphers enable-srp"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-ssl-trace enable-rc5 enable-rc2 enable-3des enable-des"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-cms enable-md2 enable-mdc2 enable-ec enable-ec2m enable-ecdh enable-ecdsa"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-seed enable-camellia enable-idea enable-rfc3779"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-dtls1 enable-threads"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-ec_nistp_64_gcc_128"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-aesgcm enable-aes-enable enable-dh enable-adh enable-edh enable-dhe"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-export enable-export40 enable-export56 enable-export1024 enable-srp enable-gost"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-dso enable-ccgost"
export SSL_BUILD_OPTS="${SSL_BUILD_OPTS} enable-comp"

# shellcheck disable=SC2155
export MAKE="make"

${MAKE} clean
# shellcheck disable=SC2086
./config ${SSL_BUILD_OPTS} shared
${MAKE} depend
${MAKE}
ENGINES_DIR="${BUILD_DIR}/openssl-${OPENSSL_VERSION}/engines"
# enable host during tests cannot leave it with gost enabled - dynamic_path had to be set correctly
sed -ri "s@dynamic_path[ ]*=[ ]*(.+)/libgost.so@dynamic_path = ${ENGINES_DIR}/ccgost/libgost.so@g" apps/openssl.cnf
${MAKE} test
${MAKE} install
# set (fix) GOST SO installation path
sed -ri "s@dynamic_path[ ]*=[ ]*(.+)/libgost.so@dynamic_path = ${INSTALL_DIR}/lib/engines/libgost.so@g" "${INSTALL_DIR}"/openssl.cnf

find "${OPENSSL_DIR}/lib" -type f -name 'lib*.a' -delete
rm -rf "${BUILD_DIR}" "${SSL_CONF_DIR}"/man "${INSTALL_DIR}"/share/man

#echo "${OPENSSL_DIR}/lib" > /etc/ld.so.conf.d/openssl.conf || true
ldconfig "${OPENSSL_DIR}/lib"

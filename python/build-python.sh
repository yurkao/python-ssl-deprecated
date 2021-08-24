#!/usr/bin/env sh

cleanup() {
  rm -rf "${OPENSSL_DIR}/include/openssl"
  rm -rf "${PYTHON_SRC_DIR}"
# shellcheck disable=SC2086
  ${PKG_DEL} ${BUILD_DEPS} && ${CLEAR_CACHE} && rm -rf /var/lib/apt/lists
}

trap cleanup EXIT

BUILD_DIR="$(mktemp -d)"
export LDFLAGS="-L${INSTALL_DIR}/lib/ -L${INSTALL_DIR}/lib64/ -Wl,--strip-all"
export LD_LIBRARY_PATH="${INSTALL_DIR}/lib/:${INSTALL_DIR}/lib64/"
export CPPFLAGS="-I${INSTALL_DIR}/include -I${INSTALL_DIR}/include/openssl"
export CFLAGS="-I${INSTALL_DIR}/include -I${INSTALL_DIR}/include/openssl"
export EXTRA_CFLAGS="-DTHREAD_STACK_SIZE=0x100000"

$CACHE_UPDATE
# shellcheck disable=SC2086
$PKG_ADD ${BUILD_DEPS}
$PKG_ADD ca-certificates tzdata
set -x
wget --quiet -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz"
mkdir -p "${BUILD_DIR}"
tar -xJC "${BUILD_DIR}" --strip-components=1 -f python.tar.xz
rm python.tar.xz
cd "${BUILD_DIR}" || exit 1

make clean || true
ARCH="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
./configure --build="${ARCH}" --enable-loadable-sqlite-extensions \
  --enable-optimizations --enable-option-checking=fatal \
  --with-system-expat --with-ssl-default-suites=openssl \
  --with-openssl="${INSTALL_DIR}" --prefix="${INSTALL_DIR}"

make
make install

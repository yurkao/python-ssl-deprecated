#!/usr/bin/env sh
. /tests/common

remove_py_tests() {
  for name in "test" tests idle_test; do
    find "${INSTALL_DIR}" -type d -name "${name}" -print0 | xargs --no-run-if-empty --null rm -rf
  done
}

remove_py_cache() {
  for ext in test pyc pyo; do
    find "${INSTALL_DIR}" -type f -name "*.${ext}" -delete
  done
}

${CACHE_UPDATE}
# shellcheck disable=SC2086
${PKG_ADD} ${BUILD_DEPS} >/dev/null

BUILD_DIR="$(mktemp -d)"
wget --quiet -O "${BUILD_DIR}"/python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz"
tar -xJC "${BUILD_DIR}" --strip-components=1 -f "${BUILD_DIR}"/python.tar.xz
cd "${BUILD_DIR}" || exit 1

apply_patches "${PYTHON_PATCH_DIR}"
sed -ri "s@SSL=/.+@SSL=${OPENSSL_DIR}@g" Modules/Setup
export LDFLAGS="-L${OPENSSL_DIR}/lib -Wl,--strip-all"
export LD_LIBRARY_PATH="${OPENSSL_DIR}/lib"
#export LD_RUN_PATH="${OPENSSL_DIR}/lib"
export CFLAGS="-I${OPENSSL_DIR}/include -I${OPENSSL_DIR}/include/openssl -I/usr/include -I/usr/include/uuid"
export CPPFLAGS="${CFLAGS}"
export EXTRA_CFLAGS="-DTHREAD_STACK_SIZE=0x100000"

ARCH="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
make clean || true

./configure --build="${ARCH}" -C --enable-loadable-sqlite-extensions \
  --enable-optimizations --enable-option-checking=fatal \
  --with-system-expat --with-ssl-default-suites=openssl --enable-shared \
  --with-openssl="${OPENSSL_DIR}" --prefix="${INSTALL_DIR}"

CORES="$(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')"
MAKE="make -j${CORES}"
${MAKE}
${MAKE} test
${MAKE} install
echo "${INSTALL_DIR}/lib" > "/etc/ld.so.conf.d/python-${PYTHON_VERSION}.conf"
ldconfig
find "${INSTALL_DIR}" -type f -name '*.a' -print0 | xargs --no-run-if-empty -0 rm -f
find "${OPENSSL_DIR}" -type f -name '*.a' -print0 | xargs --no-run-if-empty -0 rm -f
rm -rf "${OPENSSL_DIR}/include"
remove_py_tests
remove_py_cache

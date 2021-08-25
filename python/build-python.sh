#!/usr/bin/env sh

patch_modules_setup() {
  # cannot use regular patch mechanism since we have to "render" SSL=....
  export MOD_SETUP="Modules/Setup"
  # shellcheck disable=SC2129
  echo '_socket socketmodule.c' >> "${MOD_SETUP}"
  echo "SSL=${OPENSSL_DIR}"  >> "${MOD_SETUP}"
  # shellcheck disable=SC1003
  echo '_ssl _ssl.c \' >> "${MOD_SETUP}"
  # shellcheck disable=SC1003
  # shellcheck disable=SC2016
  echo '  -DUSE_SSL -I$(SSL)/include -I$(SSL)/include/openssl \'  >> "${MOD_SETUP}"
  # shellcheck disable=SC2016
  echo '  -L$(SSL)/lib -lssl -lcrypto'  >> "${MOD_SETUP}"
}

remove_py_tests() {
  for name in test tests idle_test; do
    find "${INSTALL_DIR}" -type d -name "${name}" -print0 | xargs --no-run-if-empty --null rm -rf
  done
}

remove_py_cache() {
  for ext in test pyc pyo; do
    find "${INSTALL_DIR}" -type f -name "*.${ext}" -delete
  done
}

cleanup() {
  cd /
  rm -rf "${OPENSSL_DIR}/include/openssl"
  rm -f  /tmp/*.pem  # test certificates
  rm -f "${BUILD_DIR}"/python.tar.xz
  rm -rf "${PYTHON_SRC_DIR}" "${BUILD_DIR}" "${INSTALL_DIR}"/include
  # remove static libs to preserve image space
  find "${INSTALL_DIR}" -type f -name '*.a' -print0 | xargs --no-run-if-empty -0 rm -f
  remove_py_tests
  remove_py_cache
# shellcheck disable=SC2086
  ${PKG_DEL} ${BUILD_DEPS} >/dev/null 2>&1 && ${CLEAR_CACHE} && rm -rf /var/lib/apt/lists
}

trap cleanup EXIT

${CACHE_UPDATE}
# shellcheck disable=SC2086
${PKG_ADD} ${BUILD_DEPS}
${PKG_ADD} ca-certificates tzdata

export LDFLAGS="-L${INSTALL_DIR}/lib/ -L${INSTALL_DIR}/lib64/ -Wl,--strip-all "
export LD_LIBRARY_PATH="${INSTALL_DIR}/lib/:${INSTALL_DIR}/lib64/"
export CFLAGS="-I${INSTALL_DIR}/include -I${INSTALL_DIR}/include/openssl -I/usr/include -I/usr/include/uuid"
export CPPFLAGS="${CFLAGS}"
export EXTRA_CFLAGS="-DTHREAD_STACK_SIZE=0x100000"

BUILD_DIR="$(mktemp -d)"
wget --quiet -O "${BUILD_DIR}"/python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz"
mkdir -p "${BUILD_DIR}"

tar -xJC "${BUILD_DIR}" --strip-components=1 -f "${BUILD_DIR}"/python.tar.xz
cd "${BUILD_DIR}" || exit 1

export LD_RUN_PATH="${OPENSSL_DIR}/lib"
patch_modules_setup
QUILT_PATCHES="${PYTHON_PATCH_DIR}" quilt push -a

ARCH="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"

make clean || true
./configure --build="${ARCH}" -C --enable-loadable-sqlite-extensions \
  --enable-optimizations --enable-option-checking=fatal \
  --with-system-expat --with-ssl-default-suites=openssl \
  --with-openssl="${OPENSSL_DIR}" --prefix="${INSTALL_DIR}" --enable-shared

make
make test
make install
ldconfig

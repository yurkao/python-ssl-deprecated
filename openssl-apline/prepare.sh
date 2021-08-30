export OPENSSL_VERSION=1.0.2u
export OPENSSL_DIR=/usr/local/openssl
export INSTALL_DIR="${OPENSSL_DIR}"
#export LD_LIBRARY_PATH="${INSTALL_DIR}/lib:$LD_LIBRARY_PATH"
export PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/sbin:$PATH"
export SSL_CONF_DIR="${OPENSSL_DIR}"
export OPENSSL_PATCH_DIR="/openssl.patches"
export TEST_DIR=/tests
export CACHE_UPDATE="apk update"
export PKG_ADD='apk add --no-cache --virtual'
export PKG_DEL=export QUILT_NO_DIFF_INDEX=1
export QUILT_NO_DIFF_TIMESTAMPS=1
export QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"
export QUILT_PATCH_OPTS="--reject-format=unified"


export BUILD_DEPS="libffi-dev zlib-dev ca-certificates quilt make makedepend linux-headers libc-dev gcc"
export TEST_DIR=/tests
export QUILT_NO_DIFF_INDEX=1
export QUILT_NO_DIFF_TIMESTAMPS=1
export QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"
export QUILT_PATCH_OPTS="--reject-format=unified"

ADD run-tests /sbin/
ADD tests ${TEST_DIR}/
ADD build-openssl.sh /sbin/
ADD patches-"${OPENSSL_VERSION}"/* "${OPENSSL_PATCH_DIR}"/

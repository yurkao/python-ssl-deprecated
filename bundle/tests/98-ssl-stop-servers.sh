#!/usr/bin/env sh

# shellcheck disable=SC1090
. "${TEST_DIR}/common"
${CACHE_UPDATE} && ${PKG_ADD} procps > /dev/null
start "Stopping test servers"
pkill -9 openssl || true
${PKG_DEL} procps && ${CLEAR_CACHE}

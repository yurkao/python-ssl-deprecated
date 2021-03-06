#!/usr/bin/env sh

# shellcheck disable=SC1090
. "${TEST_DIR}/common"
rv=0

SUITE_ALIASES="DEFAULT COMPLEMENTOFDEFAULT ALL COMPLEMENTOFALL HIGH MEDIUM LOW NULL RSA AECDH ECDH 3DES CAMELLIA DES"
for suite in ${SUITE_ALIASES}; do
  if ! test_ssl_cipher "$suite"; then
    rv=1
  fi
done
exit $rv

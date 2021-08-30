#!/usr/bin/env sh

# shellcheck disable=SC1090
. "${TEST_DIR}/common"
rv=0
GOST_SUITES="aGOST aGOST01 aGOST94 kGOST GOST94 GOST89MAC"
for suite in ${GOST_SUITES}; do
  msg="Checking ${suite} GOST suite"
  start "$msg"
  if ! openssl ciphers "${suite}" > /dev/null; then
    failed "$msg"
    rv=1
  else
    ok "$msg"
  fi
done
exit $rv

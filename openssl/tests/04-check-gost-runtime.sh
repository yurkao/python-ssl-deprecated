#!/usr/bin/env sh

# shellcheck disable=SC1090
. "${TEST_DIR}/common"
rv=0
start "Checking GOST run-time"
openssl genpkey -algorithm gost2001 -pkeyopt paramset:A -out seckey.pem > /dev/null || rv=1
rm -f  seckey.pem
if [ $rv -ne 0 ] ; then
  failed "Checking GOST run-time"
  rv=1
else
  ok "Checking GOST run-time"

fi
exit $rv

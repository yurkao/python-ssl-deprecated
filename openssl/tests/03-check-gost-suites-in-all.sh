#!/usr/bin/env sh

# shellcheck disable=SC1090
. "${TEST_DIR}/common"
rv=0
msg="Checking GOST ciphers availability in ALL ciphers"
start "$msg"
openssl ciphers ALL | grep -i gost || rv=1
if [ $rv -ne 0 ] ; then
  failed "$msg"
  rv=1
else
  ok "$msg"
fi
exit $rv

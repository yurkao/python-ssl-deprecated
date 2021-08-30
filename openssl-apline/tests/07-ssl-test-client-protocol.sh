#!/usr/bin/env sh

# shellcheck disable=SC1090
. "${TEST_DIR}/common"
rv=0
for protocol in ${SSL_PROTOCOLS}; do
  port_var=$(test_port "${protocol}")
  msg="Testing SSL/TLS connection on ${port_var} with ${protocol}"
  start "$msg"

  if ! echo | openssl s_client -CAfile "${CA_CRT}" "-${protocol}" -connect  "$(hostname -f):${port_var}" > /dev/null; then
    rv=1
    failed "$msg"
  else
    ok "$msg"
  fi
  echo
  echo
  echo
done
exit $rv

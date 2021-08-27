#!/usr/bin/env sh

# shellcheck disable=SC1090
. "${TEST_DIR}/common"
set -x
for protocol in ${SSL_PROTOCOLS}; do
  port_var=$(test_port "${protocol}")
  start "Starting SSL/TLS server on ${port_var} with ${protocol}"
  openssl s_server -"${protocol}" -key "${CA_KEY}" -cert "${CA_CRT}" -accept "${port_var}" -www &
done
export PATH="/usr/local/bin:path"
export protocol=ssl3
export port_var=1444
openssl s_server -"${protocol}" -engine gost -cipher aGOST -key "${CA_KEY}" -cert "${CA_CRT}" -accept "${port_var}" -www
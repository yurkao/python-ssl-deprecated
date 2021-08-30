#!/usr/bin/env sh

# shellcheck disable=SC1090
. "${TEST_DIR}/common"
for protocol in ${SSL_PROTOCOLS}; do
  port_var=$(test_port "${protocol}")
  start "Starting SSL/TLS server on ${port_var} with ${protocol}"
  openssl s_server -"${protocol}" -key "${CA_KEY}" -cert "${CA_CRT}" -accept "${port_var}" -www &
done

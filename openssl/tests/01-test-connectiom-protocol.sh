#!/usr/bin/env sh

# shellcheck disable=SC1090
. "${TEST_DIR}/common"
CA_CERT="/etc/ssl/certs/ca-certificates.crt"

if [ -z "$TEST_SERVER" ]; then
  echo SSL/TLS Test server is not set
  exit 1

fi
if [ ! -f "${CA_CERT}" ]; then
  echo CA certificate file noi found: "${CA_CERT}"
  exit 1
fi
rv=0
for protocol in ${SSL_PROTOCOLS}; do
  if ! test_ssl_connection "$protocol" "$TEST_SERVER" "${CA_CERT}" ; then
    rv=1
  fi
done
exit $rv

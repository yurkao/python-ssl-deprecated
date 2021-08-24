#!/usr/bin/env sh
# shellcheck disable=SC1090
. "${TEST_DIR}/common"
# shellcheck disable=SC1090
. "${TEST_DIR}/python-common"

rv=0
for protocol in $PY_SSL_PROTOCOLS; do
  test_name="Test creating SSLContext(ssl.PROTOCOL_${protocol})"
  start "${test_name}"
  if ! python -c "import ssl; ssl.SSLContext(ssl.PROTOCOL_${protocol})" > /dev/null; then
    failed "${test_name}"
    rv=1
  else
    ok "${test_name}"
  fi
done
exit $rv

#!/usr/bin/env sh
# shellcheck disable=SC1090
. "${TEST_DIR}/common"
# shellcheck disable=SC1090
. "${TEST_DIR}/python-common"

for protocol in $PY_SSL_PROTOCOLS; do
  test_name="Test ssl.HAS_${protocol}"
  start "${test_name}"
  if ! "${PYTHON}" -c "import ssl; assert ssl.HAS_${protocol}" > /dev/null; then
    failed "${test_name}"
    rv=1
  else
    ok "${test_name}"
  fi
done

exit $rv
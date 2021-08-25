#!/usr/bin/env sh
# shellcheck disable=SC1090
. "${TEST_DIR}/common"
# shellcheck disable=SC1090
. "${TEST_DIR}/python-common"

start "Testing ssl import"
if ! "${PYTHON}" -c 'import ssl'; then
    failed "Testing ssl import"
fi
ok "Testing ssl import"

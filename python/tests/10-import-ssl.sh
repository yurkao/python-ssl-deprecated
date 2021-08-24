#!/usr/bin/env sh
# shellcheck disable=SC1090
. "${TEST_DIR}/common"

start "Testing ssl import"
if ! python -c 'import ssl'; then
    failed "Testing ssl import"
fi
ok "Testing ssl import"

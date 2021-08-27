#!/usr/bin/env sh

# shellcheck disable=SC1090
. "${TEST_DIR}/common"

start "Removing test CA certificate"
rm -f "${CA_KEY}" "${CA_CRT}"

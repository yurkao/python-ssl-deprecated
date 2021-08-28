#!/usr/bin/env sh

# shellcheck disable=SC1090
. "${TEST_DIR}/common"

start "Generating test CA certificate"
SUBJECT="/C=XY/ST=XY/L=XY/O=XY/OU=root/CN=$(hostname -f)"
openssl req -nodes -x509 -newkey rsa:2048 -keyout "${CA_KEY}" -out "${CA_CRT}" -subj "${SUBJECT}" > /dev/null 2>&1


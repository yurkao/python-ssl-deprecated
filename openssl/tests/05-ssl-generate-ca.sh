#!/usr/bin/env sh

# shellcheck disable=SC1090
. "${TEST_DIR}/common"

start "Generating test CA certificate"
# this is to generate ca w/o prompt
# AB is for country code - should be of 2 symbols
yes AB | openssl req -x509 -newkey rsa:2048 -keyout "${CA_KEY}" -out "${CA_CRT}" -days 365 -nodes > /dev/null


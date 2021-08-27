#!/usr/bin/env sh

# shellcheck disable=SC1090
. "${TEST_DIR}/common"

start "Testing NGINX configuration"
if ! nginx -t; then
  failed "Testing NGINX configuration"
  exit 1
fi
ok "Testing NGINX configuration"

#!/usr/bin/env sh
set -e
sh -e /sbin/patch-ciphers.sh
if ! nginx -t; then
  cat  /usr/local/nginx/conf/nginx.conf;
  exit 1
fi
nginx

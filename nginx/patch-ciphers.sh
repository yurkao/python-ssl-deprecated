#!/usr/bin/env sh
if  [ -z "$CIPHERS" ]; then
  echo "Patching ciphers with ALL:NULL in strength reverse order"
  CIPHERS="$(openssl ciphers 'ALL:NULL:@STRENGTH' | tr : '\n'| tac | tr '\n' :)"
else
  echo "Patching ciphers user-defined value: ${CIPHERS}"
  CIPHERS="$(openssl ciphers "${CIPHERS}")"
fi

test -n "${CIPHERS}" || exit 1
sed -ri "s/ssl_ciphers .+;/ssl_ciphers ${CIPHERS};/g" "${NGINX_DIR}"/conf/nginx.conf

if [ -n "${USE_DHPARAM}" ]; then
  DH_BITS="${DH_BITS:-128}"
  echo Generating DH params with "${DH_BITS}" bits length
  openssl dhparam -out "${NGINX_DIR}"/dhparam.pem "${DH_BITS}" > /dev/null 2>&1
  sed -ri "s@#ssl_dhparam.+;@ssl_dhparam ${NGINX_DIR}/dhparam.pem;@g"  "${NGINX_DIR}"/conf/nginx.conf
fi

SUBJECT="/C=XY/ST=XY/L=XY/O=XY/OU=root/CN=$(hostname -f)"
KEY_PATH="${NGINX_DIR}/${NGINX_KEY}"
CRT_PATH="${NGINX_DIR}/${NGINX_CRT}"

# 512 - make it short by default
RSA_BITS="${RSA_BITS:-512}"
echo RSA key with "${RSA_BITS}" bits length
openssl req -nodes -x509 -newkey rsa:"${RSA_BITS}" -keyout "${KEY_PATH}" -out "${CRT_PATH}" -subj "${SUBJECT}" > /dev/null 2>&1
sed -ri "s@ssl_certificate[ ]*/.+;@ssl_certificate ${NGINX_DIR}/${NGINX_CRT};@g" "${NGINX_DIR}/conf/nginx.conf"
sed -ri "s@ssl_certificate_key[ ]*/.+;@ssl_certificate_key ${NGINX_DIR}/${NGINX_KEY};@g" "${NGINX_DIR}/conf/nginx.conf"

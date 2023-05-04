#!/bin/sh

TRUSTED_CA_CERTIFICATES_PEM=''
# see https://go.dev/src/crypto/x509/root_linux.go
# see https://serverfault.com/a/722646
set --  "/usr/local/etc/openssl@3/cert.pem" \
        "/etc/ssl/certs/ca-certificates.crt" \
        "/etc/pki/tls/certs/ca-bundle.crt" \
        "/etc/ssl/ca-bundle.pem" \
        "/etc/pki/tls/cacert.pem" \
        "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem" \
        "/etc/ssl/cert.pem"

for PEM in "$@"; do
    if test -f "$PEM"; then
        TRUSTED_CA_CERTIFICATES_PEM=$PEM
        break
    fi
done


PORT="${PORT:-80}"
RESOLVER=$(awk 'BEGIN{ORS=" "} $1=="nameserver" {print $2}' /etc/resolv.conf)
LUA_CODE_CACHE=${LUA_CODE_CACHE:-on}

mkdir -p conf logs

# envsubst '$PORT $RESOLVER $TRUSTED_CA_CERTIFICATES_PEM $LUA_CODE_CACHE' < conf-src/nginx.conf > conf/nginx.conf
cat conf-src/nginx.conf \
    | sed "s?\$PORT?$PORT?g" \
    | sed "s?\$RESOLVER?$RESOLVER?g" \
    | sed "s?\$TRUSTED_CA_CERTIFICATES_PEM?$TRUSTED_CA_CERTIFICATES_PEM?g" \
    | sed "s?\$LUA_CODE_CACHE?$LUA_CODE_CACHE?g" \
    > conf/nginx.conf

openresty -g 'daemon off;error_log stderr debug;' -p $PWD -c conf/nginx.conf

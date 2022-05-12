#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

DOMAIN_NAME=$1

openssl req \
  -newkey rsa:2048 \
  -x509 \
  -nodes \
  -keyout "./certs/$DOMAIN_NAME.key" \
  -new \
  -out "./certs/$DOMAIN_NAME.crt" \
  -subj "/CN=*.$DOMAIN_NAME" \
  -reqexts SAN \
  -extensions SAN \
  -config <(cat /etc/ssl/openssl.cnf \
  <(printf "[SAN]\nsubjectAltName=DNS:*.%s, DNS:%s" "$DOMAIN_NAME" "$DOMAIN_NAME")) \
  -sha256 \
  -days 3650

cat "./certs/$DOMAIN_NAME.crt" "./certs/$DOMAIN_NAME.key" \
    | tee "./certs/$DOMAIN_NAME.pem"

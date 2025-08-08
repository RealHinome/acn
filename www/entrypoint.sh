#!/bin/sh

CERT_DIR="/etc/letsencrypt/live/acn.ovh"
LOCALHOST_CERT="/etc/ssl"

if [ ! -f "$CERT_DIR/fullchain.pem" ] || [ ! -f "$CERT_DIR/privkey.pem" ]; then
  echo "let's encrypt certificates haven't been created yet"
  mkdir -p "$CERT_DIR"
  cp "$LOCALHOST_CERT/localhost.crt" "$CERT_DIR/fullchain.pem"
  cp "$LOCALHOST_CERT/localhost.key" "$CERT_DIR/privkey.pem"
fi

nginx -g "daemon off;"
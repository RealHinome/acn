#!/bin/bash

mkdir -p ./certs

openssl req -x509 -nodes -days 365 \
  -subj "/CN=localhost" \
  -newkey rsa:4096 \
  -keyout ./certs/localhost.key \
  -out ./certs/localhost.crt

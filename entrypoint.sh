#!/bin/bash
set -e

# Install envsubst if it's not present (Ubuntu images often include it in gettext-base)
# The ubuntu/bind9 image should have this, but it's good for robustness
if ! command -v envsubst &> /dev/null
then
    echo "envsubst not found. Installing..."
    apt-get update
    apt-get install -y gettext-base
fi

echo "Processing Bind9 configuration templates..."

# Process named.conf.options
envsubst < /etc/bind/named.conf.template > /etc/bind/named.conf

# Process named.conf.options
envsubst < /etc/bind/named.conf.options.template > /etc/bind/named.conf.options

# Process the main zone file and rename it
envsubst < /etc/bind/zones/db.domain.template > /etc/bind/zones/db.domain
mv /etc/bind/zones/db.domain /etc/bind/zones/db.${DOMAIN_NAME}

# Check generated configurations for syntax errors
echo "Checking generated configuration files..."
named-checkconf /etc/bind/named.conf.options
#named-checkzone "${DOMAIN_NAME}" "/etc/bind/zones/db.${DOMAIN_NAME}"

echo "Configuration processing complete. Starting Bind9..."

# Execute the original Bind9 entrypoint or command
exec /usr/sbin/named -g -c /etc/bind/named.conf -u bind
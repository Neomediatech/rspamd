#!/bin/sh

SECURE_IP=${SECURE_IP:-"127.0.0.1"}
PASSWORD=${PASSWORD:-"SomeSecurePassword"}
ENABLE_PASSWORD=${ENABLE_PASSWORD:-$PASSWORD}

cat << EOF > /etc/rspamd/local.d/worker-controller.inc
secure_ip = "${SECURE_IP}";
password = "${PASSWORD}";
enable_password = "${PASSWORD}";
EOF


rspamd -i
tail -f /var/log/rspamd/rspamd.log

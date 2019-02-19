#!/bin/sh

SECURE_IP=${SECURE_IP:-"127.0.0.1"}
PASSWORD=${PASSWORD:-"SomeSecurePassword"}
ENABLE_PASSWORD=${ENABLE_PASSWORD:-$PASSWORD}

cat << EOF > /etc/rspamd/local.d/worker-controller.inc
bind_socket = "0.0.0.0:11334";
secure_ip = "${SECURE_IP}";
password = "${PASSWORD}";
enable_password = "${PASSWORD}";
EOF

LOGFILE="/var/log/rspamd/rspamd.log"

mkdir -p /var/lib/rspamd/dynamic /var/log/rspamd
chown rspamd:rspamd /var/lib/rspamd/dynamic
if [ ! -f $LOGFILE ]; then
    touch $LOGFILE
    chown rspamd:rspamd $LOGFILE
fi

rspamd -i
tail -f /var/log/rspamd/rspamd.log 

#!/bin/bash

PWCLEAR="$(echo {A..Z} {a..z} {0..9} {0..9} '@ # % ^ ( ) _ + = - [ ] { } . ?' | tr ' ' "\n" | shuf | xargs | tr -d ' ' | cut -b 1-12)"
PWCRYPT="$(rspamadm pw -e -p $PWCLEAR)"

SECURE_IP=${SECURE_IP:-"127.0.0.1"}
PASSWORD=${PASSWORD:-"$PWCRYPT"}
#ENABLE_PASSWORD=${ENABLE_PASSWORD:-$PASSWORD}

# Check custom configuration files
CUSTOM_CONF_BASE_DIR="/data"
CUSTOM_CONF_DIRS="local.d local.d/maps.d override.d plugins.d"
for DIR in $CUSTOM_CONF_DIRS; do
  CUSTOM_CONF_DIR="$CUSTOM_CONF_BASE_DIR/$DIR"
  if [ -d "$CUSTOM_CONF_DIR" ]; then
    echo "Checking for custom configuration files in ${CUSTOM_CONF_DIR}..."
    find "$CUSTOM_CONF_DIR" -maxdepth 1 -type f -name '[!.]*.*' -printf "%f\n"| while read CONFIG_FILE ; do
      if [ -f "/etc/rspamd/${DIR}/${CONFIG_FILE}" ]; then
        echo "  WARNING: ${CONFIG_FILE} already exists and will be overriden"
        rm -f "/etc/rspamd/${DIR}/${CONFIG_FILE}"
      fi
      echo "  Add custom config file ${CONFIG_FILE}..."
      [ ! -d "/etc/rspamd/${DIR}/" ] && mkdir -p "/etc/rspamd/${DIR}/"
      [ "${CONFIG_FILE##*.}" = "map" -o "${CONFIG_FILE##*.}" = "local" ] && chmod 666 "/data/${DIR}/${CONFIG_FILE}"
      ln -sf "/data/${DIR}/${CONFIG_FILE}" "/etc/rspamd/${DIR}/"
    done
  fi
done

# Check for custom rspamd.conf config
GLOBAL_CUSTOM_CONF_FILE="$CUSTOM_CONF_BASE_DIR/local.d/rspamd.conf.local"
if [ -f $GLOBAL_CUSTOM_CONF_FILE ]; then
  echo "Add custom config file rspamd.conf.local"
  rm -f /etc/rspamd/rspamd.conf.local
  ln -sf $CUSTOM_CONF_BASE_DIR/local.d/rspamd.conf.local /etc/rspamd/
fi

if [ ! -f /etc/rspamd/local.d/worker-controller.inc ]; then
cat << EOF > /etc/rspamd/local.d/worker-controller.inc
bind_socket = "0.0.0.0:11334";
secure_ip = "${SECURE_IP}";
password = "${PASSWORD}";
#enable_password = "${PASSWORD}";
EOF
        echo " "
        echo " "
        echo "      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	echo " "
        echo "      THE PASSWORD TO ACCESS THE WEB UI IS:  $PWCLEAR"
        echo " "
        echo "      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
        echo " "
        echo " "
else
	echo " "
	echo " "
	echo "      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	echo "      IF YOU DIDN'T SET '\$PASSWORD' VARIABLE"
	echo "      OR IF YOU DON'T KNOW WHAT I'M SAYING"
	echo "      AND YOU DON'T KNOW THE PASSWORD TO ACCESS"
	echo "      THE WEB UI, THEN ENTER THE CONTAINER AND"
	echo "      DELETE THE FILE /etc/rspamd/local.d/worker-controller.inc"
	echo "      THEN RESTART THE CONTAINER AND SHOW THE CONSOLE LOGS"
	echo "      THE PASSWORD WILL BE PUT ON THE SCREEN"
	echo "      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
	echo " "
	echo " "
fi

LOGFILE="/var/log/rspamd/rspamd.log"

[ ! -d /var/log/rspamd ] && mkdir -p /var/log/rspamd
[ ! -d /run/rspamd ]     && mkdir -p /run/rspamd && chown _rspamd:_rspamd /run/rspamd

[ ! -f $LOGFILE ] && touch $LOGFILE && chown _rspamd:_rspamd $LOGFILE

# Variable WAITFOR set as a space separated series of comma separated values
# i.e.: "my_clamav:clamav:3310
# 3rd parameter (port) can be omitted for default ports
check_service() {
  until eval $1 ; do
    sleep 1
    echo -n "..."
  done
  echo -n "OK"
}
if [ -n "$WAITFOR" ]; then
  for CHECK in $WAITFOR; do
    IFS=':' read -a SERVICE <<< "$CHECK"
    # while array: ${SERVICE[*]}
    NAME="${SERVICE[0]}"
    SRV="${SERVICE[1]}"
    PORT="${SERVICE[2]}"
    if [ -z "$NAME" -o -z "$SRV" ]; then
      continue
    fi
    echo -n "Checking for service $SRV on $NAME..."
    case "$SRV" in
      "clamav")
        PORT=${PORT:-3310}
        check_service 'echo PING | nc -w 5 $NAME $PORT 2>/dev/null'
        ;;
      "rspamd")
        check_service 'ping -c1 $NAME 1>/dev/null 2>/dev/null'
        ;;
      "redis")
        PORT=${PORT:-6379}
        check_service 'timeout 2 redis-cli -h $NAME -p $PORT PING'
        ;;
      *)
        check_service 'ping -c1 $NAME 1>/dev/null 2>/dev/null'
        ;;
    esac
    echo " "
  done
fi

exec tail -F $LOGFILE &
#rspamd -i -f
exec "$@"

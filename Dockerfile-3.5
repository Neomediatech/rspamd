FROM neomediatech/ubuntu-base:20.04

ENV RSPAMD_VERSION=3.5-2~0c671194e~focal \
    SERVICE=rspamd

LABEL maintainer="docker-dario@neomediatech.it" \ 
      org.label-schema.version=$RSPAMD_VERSION \
      org.label-schema.vcs-type=Git \
      org.label-schema.vcs-url=https://github.com/Neomediatech/${SERVICE} \
      org.label-schema.maintainer=Neomediatech

RUN apt-get update && apt-get -y dist-upgrade && \
    apt-get install -y --no-install-recommends \
    ca-certificates lsb-release wget gnupg && \
    CODENAME=`lsb_release -c -s` && \
    wget -O- https://rspamd.com/apt-stable/gpg.key | apt-key add - && \
    echo "deb [arch=amd64] http://rspamd.com/apt-stable/ $CODENAME main" > /etc/apt/sources.list.d/rspamd.list && \
    echo "deb-src [arch=amd64] http://rspamd.com/apt-stable/ $CODENAME main" >> /etc/apt/sources.list.d/rspamd.list && \
    apt-get update && \
    apt-get --no-install-recommends install -y rspamd && \
    rm -rf /var/lib/apt/lists/* && \
    echo 'pidfile = false;' > /etc/rspamd/override.d/options.inc && \
    mkdir -p /srv/scripts && \
    wget -O /srv/scripts/logrotate.sh https://raw.githubusercontent.com/Neomediatech/assets/main/scripts/logrotate.sh && \
    chmod +x /srv/scripts/logrotate.sh

COPY conf/ /etc/rspamd
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

HEALTHCHECK --interval=30s --timeout=30s --start-period=10s --retries=20 CMD rspamadm control stat |grep uptime|head -1 || ( echo "no uptime, no party\!" && exit 1 )

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "/usr/bin/rspamd", "-f", "-u", "_rspamd", "-g", "_rspamd" ]

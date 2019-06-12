FROM ubuntu:18.04

ENV RSPAMD_VERSION=1.9.4

LABEL maintainer="docker-dario@neomediatech.it" \ 
      org.label-schema.version=$EXIM__VERSION \
      org.label-schema.vcs-type=Git \
      org.label-schema.vcs-url=https://github.com/Neomediatech/rspamd-ubuntu \
      org.label-schema.maintainer=Neomediatech

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Rome

RUN apt-get update && apt-get install -y lsb-release wget gnupg netcat && \ 
    CODENAME=`lsb_release -c -s` && \ 
    wget -O- https://rspamd.com/apt-stable/gpg.key | apt-key add - && \ 
    echo "deb [arch=amd64] http://rspamd.com/apt-stable/ $CODENAME main" > /etc/apt/sources.list.d/rspamd.list && \ 
    echo "deb-src [arch=amd64] http://rspamd.com/apt-stable/ $CODENAME main" >> /etc/apt/sources.list.d/rspamd.list && \ 
    apt-get update && \ 
    apt-get --no-install-recommends install -y rspamd && \ 
	rm -rf /var/lib/apt/lists/*

COPY conf/ /etc/rspamd
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["rspamd","-i","-f"]

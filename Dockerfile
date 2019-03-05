FROM ubuntu:18.04

LABEL maintainer="docker-dario@neomediatech.it"

RUN apt-get update && apt-get install -y lsb-release wget && \ 
    CODENAME=`lsb_release -c -s` && \ 
    wget -O- https://rspamd.com/apt-stable/gpg.key | apt-key add - && \ 
    echo "deb [arch=amd64] http://rspamd.com/apt-stable/ $CODENAME main" > /etc/apt/sources.list.d/rspamd.list && \ 
    echo "deb-src [arch=amd64] http://rspamd.com/apt-stable/ $CODENAME main" >> /etc/apt/sources.list.d/rspamd.list && \ 
    apt-get update && \ 
    apt-get --no-install-recommends install rspamd && \ 
	rm -rf /var/lib/apt/lists/*
    
#RUN apk update; apk upgrade ; apk add --no-cache tzdata; cp /usr/share/zoneinfo/Europe/Rome /etc/localtime ; \ 
#    apk add --no-cache tini rspamd rspamd-controller rsyslog ca-certificates bash && \ 
#    rm -rf /usr/local/share/doc /usr/local/share/man && \ 
#    mkdir /run/rspamd

COPY conf/ /etc/rspamd
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
#CMD ["tini","--","rspamd","-i","-f"]
CMD ["rspamd","-i","-f"]

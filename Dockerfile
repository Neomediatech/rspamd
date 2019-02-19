FROM alpine:latest

LABEL maintainer="docker-dario@neomediatech.it"

RUN apk update; apk upgrade ; apk add --no-cache tzdata; cp /usr/share/zoneinfo/Europe/Rome /etc/localtime ; \ 
    apk add --no-cache rspamd rspamd-controller rsyslog ca-certificates ; \ 
    rm -rf /usr/local/share/doc /usr/local/share/man ; \ 
    mkdir /run/rspamd

COPY conf/ /etc/rspamd
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

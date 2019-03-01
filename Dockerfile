FROM alpine:3.9

LABEL maintainer="docker-dario@neomediatech.it"

RUN apk update; apk upgrade ; apk add --no-cache tzdata; cp /usr/share/zoneinfo/Europe/Rome /etc/localtime ; \ 
    apk add --no-cache rspamd rspamd-controller rsyslog ca-certificates bash && \ 
    rm -rf /usr/local/share/doc /usr/local/share/man && \ 
    mkdir /run/rspamd

COPY conf/ /etc/rspamd
COPY init.sh /init.sh
RUN chmod +x /init.sh

ENTRYPOINT ["tini","-g"]
CMD ["/init.sh"]

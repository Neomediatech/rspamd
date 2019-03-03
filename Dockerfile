FROM alpine:3.9

LABEL maintainer="docker-dario@neomediatech.it"

RUN apk update; apk upgrade ; apk add --no-cache tzdata; cp /usr/share/zoneinfo/Europe/Rome /etc/localtime ; \ 
    apk add --no-cache tini rspamd rspamd-controller rsyslog ca-certificates bash && \ 
    rm -rf /usr/local/share/doc /usr/local/share/man && \ 
    mkdir /run/rspamd

COPY conf/ /etc/rspamd
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["tini","--","rspamd","-i","-f"]

FROM alpine

LABEL maintainer="docker-dario@neomediatech.it"

RUN apk update; apk upgrade ; apk add --no-cache tzdata; cp /usr/share/zoneinfo/Europe/Rome /etc/localtime
RUN apk add --no-cache rspamd rspamd-controller rsyslog ca-certificates
RUN rm -rf /usr/local/share/doc /usr/local/share/man
RUN mkdir /run/rspamd

# We have to upgrade musl, or rspamd will not work.
#RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
# && apk add --no-cache rspamd rspamd-controller rsyslog ca-certificates tzdata; rm -rf /usr/local/share/doc /usr/local/share/man; cp /usr/share/zoneinfo/Europe/Rome /etc/localtime

COPY conf/ /etc/rspamd
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

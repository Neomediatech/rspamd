in `docker-compose.yml` mount a volume to override configuration files with your own, eg: 
```
   volumes:
     - /srv/data/docker/rspamd-conf/local.d:/etc/rspamd/local.d
```
### docker-compose.yml sample file:
```
# put version file you want
version: 'xxx'

x-environment: &common-vars
    TZ: Europe/Rome

services:
  rspamd:
    image: neomediatech/rspamd-alpine:latest
    hostname: rspamd
    volumes:
      - /srv/data/docker/rspamd-conf/local.d:/etc/rspamd/local.d
      - rspamd_data:/var/lib/rspamd
    environment:
      << : *common-vars

  redis:
    image: redis:alpine
    hostname: redis
    environment:
      << : *common-vars
    command: ["redis-server", "--appendonly", "yes"]
    volumes:
      - redis_db:/data
```

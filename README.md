# Dockerized Rspamd on Alpine
Dockerized version of rspamd, based on Alpine Linux.

## Usage
You can run this container with this command:  
`docker run -d --name rspamd-alpine neomediatech/rspamd-alpine`  

Logs are written inside the container, in /var/log/rspamd/, and on stdout. You can see realtime logs running this command:  
`docker logs -f rspamd-alpine`  
`CTRL c` to stop seeing logs.  

If you want to map logs outside the container you can add:  
`-v /folder/path/on-host/logs/:/var/log/rspamd/`  
Where "/folder/path/on-host/logs/" is a folder inside your host. You have to create the host folder manually.  

You can run it on a compose file like this:  

```
version: '3'  

services:  
  rspamd:  
    image: neomediatech/rspamd-alpine:latest  
    hostname: rspamd  
```
Save on a file and then run:  
`docker stack deploy -c /your-docker-compose-file-just-created.yml rspamd`

If you want to map logs outside the container you can add:  
```
    volumes:
      - /folder/path/on-host/logs/:/var/log/rspamd/
```
Where "/folder/path/on-host/logs/" is a folder inside your host. You have to create the host folder manually.

Save on a file and then run:  
`docker stack deploy -c /your-docker-compose-file-just-created.yml rspamd`  

### docker-compose.yml sample file:
```
# put version file you want
version: 'xxx'

x-environment: &common-vars
    TZ: Europe/Rome

services:
  clamav:
    image: neomediatech/clamav-alpine:latest
    hostname: clamav
    volumes:
      - clamav_defs:/var/lib/clamav
    environment:
      << : *common-vars

  rspamd:
    image: neomediatech/rspamd-alpine
    hostname: rspamd
    volumes:
      - rspamd_data:/var/lib/rspamd
    environment:
      << : *common-vars
    depends_on:
      - redis

  dcc:
    image: neomediatech/dcc:latest
    hostname: dcc
    environment:
      << : *common-vars

  razor:
    image: neomediatech/razor:latest
    hostname: razor
    environment:
      << : *common-vars

  pyzor:
    image: neomediatech/pyzor:latest
    hostname: pyzor
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

volumes:
  common_data:
    driver: local
  webmail_app:
    driver: local
  clamav_defs:
    driver: local
  redis_db:
    driver: local
  rspamd_data:
    driver: local

```

# Dockerized Rspamd on Ubuntu
Dockerized version of rspamd, based on Ubuntu.

## ToDo
- LOG ROTATION.  
`mv rspamd.log rspamd.log.1 && touch rspamd.log && chmod 666 rspamd.log`   
(inside the container) `kill -SIGUSR1 1`  
Thanks also to `tail -F `, commands above do their the job. Maybe there are better solutions (where?)

## Usage
You can run this container with this command:  
`docker run -d --name rspamd neomediatech/rspamd`  

Logs are written inside the container, in /var/log/rspamd/, and on stdout. You can see realtime logs running this command:  
`docker logs -f rspamd`  
`CTRL c` to stop seeing logs.  

If you want to map logs outside the container you can add:  
`-v /folder/path/on-host/logs/:/var/log/rspamd/`  
Where "/folder/path/on-host/logs/" is a folder inside your host. You have to create the host folder manually.  

You can run it on a compose file like this:  

```
version: '3'  

services:  
  rspamd:  
    image: neomediatech/rspamd:latest  
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
    image: neomediatech/clamav:latest
    hostname: clamav
    volumes:
      - clamav_defs:/var/lib/clamav
    environment:
      << : *common-vars

  rspamd:
    image: neomediatech/rspamd:latest
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

  razorfy:
    image: neomediatech/razorfy:latest
    hostname: razorfy
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

## Custom files & options
- create a passowrd to access web interface:  
`docker run --rm -it neomediatech/rspamd`
put the encrypted password in your __local.d/worker-controller.inc__ :
`sed -i 's/^\(#\)\{0,1\}\( \)\{0,\}password.*/password = "your_encrypted_password";/' local.d/worker-controller.inc`  
or simply edit __local.d/worker-controller.inc__ and change or add the line  
`"password = your_encrypted_password";`
- bind mount a folder in /data/local.d container to have custom configuration files, for ex: `-v /myfolder:/data/local.d`
- .map and .local files found on /data directory will be "chmoded" to 666. By using rspamd web UI you can modify this files (lists and maps of ip, domains, mail addresses, etc...)  


| Variable | Default | Description |
| -------- | ------- | ----------- |
| tbd | tbd | to be done |

## Original rspamd tree (from Ubuntu 18.04 install) for reference
```
/etc/rspamd/
├── actions.conf
├── cgp.inc
├── common.conf
├── composites.conf
├── groups.conf
├── local.d
├── logging.inc
├── maps.d
│   ├── dmarc_whitelist.inc
│   ├── maillist.inc
│   ├── mid.inc
│   ├── mime_types.inc
│   ├── redirectors.inc
│   ├── spf_dkim_whitelist.inc
│   └── surbl-whitelist.inc
├── metrics.conf
├── modules.conf
├── modules.d
│   ├── antivirus.conf
│   ├── arc.conf
│   ├── asn.conf
│   ├── chartable.conf
│   ├── clickhouse.conf
│   ├── dcc.conf
│   ├── dkim.conf
│   ├── dkim_signing.conf
│   ├── dmarc.conf
│   ├── elastic.conf
│   ├── emails.conf
│   ├── external_services.conf
│   ├── force_actions.conf
│   ├── forged_recipients.conf
│   ├── fuzzy_check.conf
│   ├── greylist.conf
│   ├── hfilter.conf
│   ├── history_redis.conf
│   ├── maillist.conf
│   ├── metadata_exporter.conf
│   ├── metric_exporter.conf
│   ├── mid.conf
│   ├── milter_headers.conf
│   ├── mime_types.conf
│   ├── multimap.conf
│   ├── mx_check.conf
│   ├── neural.conf
│   ├── once_received.conf
│   ├── p0f.conf
│   ├── phishing.conf
│   ├── ratelimit.conf
│   ├── rbl.conf
│   ├── redis.conf
│   ├── regexp.conf
│   ├── replies.conf
│   ├── reputation.conf
│   ├── rspamd_update.conf
│   ├── spamassassin.conf
│   ├── spamtrap.conf
│   ├── spf.conf
│   ├── surbl.conf
│   ├── trie.conf
│   ├── url_redirector.conf
│   └── whitelist.conf
├── options.inc
├── override.d
├── rspamd.conf
├── scores.d
│   ├── content_group.conf
│   ├── fuzzy_group.conf
│   ├── headers_group.conf
│   ├── hfilter_group.conf
│   ├── mime_types_group.conf
│   ├── mua_group.conf
│   ├── phishing_group.conf
│   ├── policies_group.conf
│   ├── rbl_group.conf
│   ├── statistics_group.conf
│   ├── subject_group.conf
│   ├── surbl_group.conf
│   └── whitelist_group.conf
├── settings.conf
├── statistic.conf
├── worker-controller.inc
├── worker-fuzzy.inc
├── worker-normal.inc
└── worker-proxy.inc
```
## Useful infos
- `options.inc` contains reference for rspamd statistics (seen in UI)  
stats_file = "${DBDIR}/stats.ucl";  
DBDIR is (as default) /var/lib/rspamd  
`local.d/options.inc` to merge this file  
  
- `rspamc counters` shows stats for every symbol. Useful to know what symbols are involved  

- `local.d/worker-fuzzy.inc` to enable &/| fuzzy method  


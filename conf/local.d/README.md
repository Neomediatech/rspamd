in `docker-compose.yml` mount a volume to override configuration files with your own, eg: 
```
   volumes:
     - "/srv/data/docker/rspamd-conf:/var/lib/rspamd"
```

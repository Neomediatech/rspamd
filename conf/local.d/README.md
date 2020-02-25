in `docker-compose.yml` mount a volume to override configuration files with your own, eg: 
```
   volumes:
     - /srv/data/docker/rspamd-conf/local.d:/data/local.d
```

## VirusTotal support
Put in local.d/antivirus.conf this configuration:  
```
virustotal {
   apikey = "your-api-key-got-from-virustotal.com";
   # log_clean = true; # if you want to log also clean files
}
```

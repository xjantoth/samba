#!/usr/bin/env bash

echo -e "Checking for docker daemon started ..."

COUNT=0

until [ "`systemctl is-active docker`" == "active" ]; do
    
    sleep 7;
    COUNT=$((COUNT+1))
    if [[ ${COUNT} == 100 ]]; then
        echo -e "Breaking out of until loop: ${COUNT} too many retries!!! Could not start SAMBA because docker is down"
        exit 1
    fi
done;

echo "Cotinue starting SAMBA ..."


docker stop samba && docker rm samba ||  :
docker run -d  -p 135:135/tcp \
       -p 137:137/udp \
       -p 138:138/udp \
       -p 139:139/tcp \
       -p 445:445/tcp \
       -v /opt/vg_11-lv_backup_vg_11/SAMBA_los.fei.tuke/:/opt/share/ \
       -v /opt/student/:/opt/student/ \
       --name samba  \
       jantoth/samba-tuke:v0.0.2


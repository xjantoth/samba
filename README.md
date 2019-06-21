
!!!Please add user/group: samba/samba (2000/2000) at your host OS
```bash
groupadd -g 2000 samba
useradd -g  2000 -u 2000 samba -s /usr/sbin/nologin
chown -R samba.samba /opt/vg_11-...

```

Please setup SELINUX at your host filesystem

```bash
chcon -R unconfined_u:object_r:usr_t:s0 /opt/vg_11-...

semanage fcontext -a -t usr_t '/opt/vg_11-lv_backup_vg_11(/.*)?'
restorecon -R -v /opt/vg_11-lv_backup_vg_11

```

Double-check SELINUX settings
```bash
[root@localhost samba]# getsebool -a | grep 'samba\|smb'
samba_create_home_dirs --> off
samba_domain_controller --> on
samba_enable_home_dirs --> on
samba_export_all_ro --> on
samba_export_all_rw --> on
samba_load_libgfapi --> off
samba_portmapper --> on
samba_run_unconfined --> off
samba_share_fusefs --> off
samba_share_nfs --> off
sanlock_use_samba --> off
smbd_anon_write --> off
tmpreaper_use_samba --> off
use_samba_home_dirs --> off
virt_use_samba --> off

```

Ports open:
```bash
netstat -tunlp | grep -P "445|137|138|139"
firewall-cmd --permanent --zone=public --add-service=samba
firewall-cmd --list-all
``` 

Build docker image
```bash
docker build -t jantoth/samba-tuke:v0.0.1 .
docker build --build-arg PASSWORD=St..# -t jantoth/samba-tuke:v0.0.1 .
```

Quick start:
```bash
docker run -d \
       -p 135:135/tcp \
       -p 137:137/udp \
       -p 138:138/udp \
       -p 139:139/tcp \
       -p 445:445/tcp \
       -v /opt/vg_11-.../SAMBA_los.../:/opt/share/ \
       --name samba \
       jantoth/samba-tuke:v0.0.1
```

Stop samba in docker:
```bash
docker stop samba; docker rm samba
```




```bash
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
       --name samba  \
       jantoth/samba-tuke:v0.0.1

```


Crontab

```bash
crontab  -l
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed

0 23 * * * rsync -avhx /opt/vg_11-lv_backup_vg_11/SAMBA.../* /opt/vg_22-lv_backup_vg_22/SAMBA.../
@reboot /opt/scripts/start-samba-docker.sh > /opt/start-samba-docker.log 2>&1
```


Connect to SAMBA
```bash
smbclient //127.0.0.1/samba -U samba -W SAMBA
```
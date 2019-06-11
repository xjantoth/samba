
!!!Please add user/group: samba/samba (2000/2000) at your host OS
```bash
groupadd -g 2000 samba
useradd -g  2000 -u 2000 samba -s /usr/sbin/nologin
chown -R samba.samba /opt/vg_11-...

```

Please setup SELINUX at your host filesystem

```bash
chcon -R unconfined_u:object_r:usr_t:s0 /opt/vg_11-...
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
docker build --build-arg PASSWORD=Start123# -t jantoth/samba-tuke:v0.0.1 .
```

Quick start for the impatient (discovery on your network will work fine):
```shell
docker run -d --network host -v /opt/share/:/opt/share/ --name samba jantoth/samba-tuke:v0.0.1
```

Supplying port mappings only instead of --network=host might be subject to the limtations outlined above:
```shell
docker run -d -p 135:135/tcp -p 137:137/udp -p 138:138/udp -p 139:139/tcp -p 445:445/tcp -v /opt/share/:/opt/share/ --name samba jantoth/samba-tuke:v0.0.1
```

With your own smb.conf and supervisord.conf configs:
```shell
docker run -d -p 135:135/tcp -p 137:137/udp -p 138:138/udp -p 139:139/tcp -p 445:445/tcp -v /path/to/configs/:/config -v /opt/share/:/opt/share/ --name samba jantoth/samba-tuke:v0.0.1
```

To have the container start when the host boots, add docker's restart policy:
```shell
docker run -d --restart=always -p 135:135/tcp -p 137:137/udp -p 138:138/udp -p 139:139/tcp -p 445:445/tcp -v /opt/share/:/opt/share/ --name samba jantoth/samba-tuke:v0.0.1
```

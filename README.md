Build docker image
```
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

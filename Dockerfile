FROM alpine:latest

ARG PASSWORD
ARG STUDENT_PASSWORD

LABEL MAINTAINER="Jan Toth <jan.toth@gmail.com>"

# upgrade base system and install samba and supervisord
RUN apk --no-cache upgrade && apk --no-cache add samba samba-common-tools supervisor

# create a dir for the config and the share
RUN mkdir /config /opt/share

# copy config files from project folder to get a default config going for samba and supervisord
COPY *.conf /config/

# add a non-root user and group called "rio" with no password, no home dir, no shell, and gid/uid set to 1000
RUN addgroup -g 2000 samba && adduser -D -H -G samba -s /bin/false -u 2000 samba
RUN addgroup -g 3000 student && adduser -D -H -G student -s /bin/false -u 3000 student

# create a samba user matching our user from above with a very simple password ("letsdance")
RUN echo -e "$PASSWORD\n$PASSWORD" | smbpasswd -a -s -c /config/smb.conf samba

# create a "student" user matching our user from above with a very simple password ("letsdance")
RUN echo -e "$STUDENT_PASSWORD\n$STUDENT_PASSWORD" | smbpasswd -a -s -c /config/smb.conf student
# volume mappings
VOLUME /config /opt/share

# exposes samba's default ports (135 for End Point Mapper [DCE/RPC Locator Service],
# 137, 138 for nmbd and 139, 445 for smbd)
EXPOSE 135/tcp 137/udp 138/udp 139/tcp 445/tcp

ENTRYPOINT ["supervisord", "-c", "/config/supervisord.conf"]




#FROM centos:centos7
#
#RUN yum install samba samba-client
#    && systemctl start smb.service \ 
#    && systemctl start nmb.service \
#    && systemctl enable nmb.service \
#    && systemctl enable smb.service \
#    && groupadd -g 2000 samba \
#    && useradd -M -g  2000 -u 2000 samba -s /usr/sbin/nologin \
#    && smbpasswd -a samba \
#    && smbpasswd -e samba \
#    && mkdir /opt/share
#    && chown -R samba.samba /opt/share \
#    && systemctl restart smb.service \
#    && systemctl restart nmb.service 



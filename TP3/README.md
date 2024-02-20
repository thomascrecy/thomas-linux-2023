# TP3 : Appréhender l'environnement Linux

# I. Service SSH

## 1. Analyse du service

### 🌞 S'assurer que le service sshd est démarré

```
[toto@node1 ~]$ systemctl status
● node1.tp2.b1
    State: running
    Units: 281 loaded (incl. loaded aliases)
     Jobs: 0 queued
   Failed: 0 units
    Since: Tue 2024-01-23 15:13:01 CET; 1min 9s ago
  systemd: 252-13.el9_2
   CGroup: /
           ├─init.scope
           │ └─1 /usr/lib/systemd/systemd --switched-root --system --deserialize 31
           ├─system.slice
           │ ├─NetworkManager.service
           │ │ └─676 /usr/sbin/NetworkManager --no-daemon
           │ ├─auditd.service
           │ │ └─641 /sbin/auditd
           │ ├─chronyd.service
           │ │ └─671 /usr/sbin/chronyd -F 2
           │ ├─crond.service
           │ │ └─689 /usr/sbin/crond -n
           │ ├─dbus-broker.service
           │ │ ├─673 /usr/bin/dbus-broker-launch --scope system --audit
           │ │ └─675 dbus-broker --log 4 --controller 9 --machine-id abfa8e62a49a4af5b7032100e85ca92a --max-bytes 53687>
           │ ├─firewalld.service
           │ │ └─664 /usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
           │ ├─rsyslog.service
           │ │ └─665 /usr/sbin/rsyslogd -n
           │ ├─sshd.service
           │ │ └─683 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
           │ ├─systemd-hostnamed.service
```

### 🌞 Analyser les processus liés au service SSH

```
[toto@node1 ~]$ ps aux | grep sshd
root         683  0.0  1.1  15836  9224 ?        Ss   15:13   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1325  0.0  1.4  18832 11440 ?        Ss   15:14   0:00 sshd: toto [priv]
toto        1329  0.0  0.9  19016  7168 ?        S    15:14   0:00 sshd: toto@pts/0
toto        1364  0.0  0.2   6408  2296 pts/0    S+   15:19   0:00 grep --color=auto sshd
```

### 🌞 Déterminer le port sur lequel écoute le service SSH

```
[toto@node1 ~]$ ss | grep ssh
tcp   ESTAB  0      52                        10.2.1.15:ssh           10.2.1.1:56251
```

### 🌞 Consulter les logs du service SSH

```
[toto@node1 ~]$ journalctl | grep ssh
Jan 30 13:45:06 node1.tp2.b1 systemd[1]: Created slice Slice /system/sshd-keygen.
Jan 30 13:45:08 node1.tp2.b1 systemd[1]: Reached target sshd-keygen.target.
Jan 30 13:45:10 node1.tp2.b1 sshd[683]: main: sshd: ssh-rsa algorithm is disabled
Jan 30 13:45:10 node1.tp2.b1 sshd[683]: Server listening on 0.0.0.0 port 22.
Jan 30 13:45:10 node1.tp2.b1 sshd[683]: Server listening on :: port 22.
Jan 30 13:45:20 node1.tp2.b1 sshd[1300]: main: sshd: ssh-rsa algorithm is disabled
Jan 30 13:45:23 node1.tp2.b1 sshd[1300]: Accepted password for toto from 10.2.1.1 port 58640 ssh2
Jan 30 13:45:23 node1.tp2.b1 sshd[1300]: pam_unix(sshd:session): session opened for user toto(uid=1000) by (uid=0)
```

```
[toto@node1 ~]$ sudo tail /var/log/secure
Jan 23 15:13:30 node1 sshd[1303]: Disconnected from user toto 10.2.1.1 port 56232
Jan 23 15:13:30 node1 sshd[1299]: pam_unix(sshd:session): session closed for user toto
Jan 23 15:14:04 node1 sshd[1325]: Accepted password for toto from 10.2.1.1 port 56251 ssh2
Jan 23 15:14:04 node1 sshd[1325]: pam_unix(sshd:session): session opened for user toto(uid=1000) by (uid=0)
Jan 23 15:22:01 node1 sudo[1372]:    toto : TTY=pts/0 ; PWD=/home/toto ; USER=root ; COMMAND=/bin/cat /var/log/secure
Jan 23 15:22:01 node1 sudo[1372]: pam_unix(sudo:session): session opened for user root(uid=0) by toto(uid=1000)
Jan 23 15:22:01 node1 sudo[1372]: pam_unix(sudo:session): session closed for user root
Jan 23 15:22:07 node1 sudo[1377]:    toto : TTY=pts/0 ; PWD=/home/toto ; USER=root ; COMMAND=/bin/cat /var/log/secure tail
Jan 23 15:22:07 node1 sudo[1377]: pam_unix(sudo:session): session opened for user root(uid=0) by toto(uid=1000)
Jan 23 15:22:07 node1 sudo[1377]: pam_unix(sudo:session): session closed for user root
```

## 2. Modification du service

### 🌞 Identifier le fichier de configuration du serveur SSH

```
[toto@node1 ssh]$ sudo cat sshd_config
[sudo] password for toto:
#       $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile      .ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no

# Change to no to disable s/key passwords
#KbdInteractiveAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in RHEL and may cause several
# problems.
#UsePAM no

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem       sftp    /usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server
```

### 🌞 Modifier le fichier de conf

```
[toto@node1 ssh]$ echo $RANDOM
21157
```

```
[toto@node1 ssh]$ sudo cat sshd_config | grep -i port
# If you want to change the port on a SELinux system, you have to tell
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#Port 21157
# WARNING: 'UsePAM no' is not supported in RHEL and may cause several
#GatewayPorts no
```

```
[toto@node1 ssh]$ sudo firewall-cmd --list-all | grep -i port
  ports: 21157/tcp
  forward-ports:
  source-ports:
```

### 🌞 Redémarrer le service

```
[toto@node1 ~]$ sudo systemctl restart sshd
```

### 🌞 Effectuer une connexion SSH sur le nouveau port

```
PS C:\Users\crecy> ssh toto@10.2.1.15 -p 21157
toto@10.2.1.15's password:
Last login: Tue Jan 30 14:29:14 2024 from 10.2.1.1
```

# II. Service HTTP

## 1. Mise en place

### 🌞 Installer le serveur NGINX

```
[toto@node1 ~]$ sudo dnf install nginx
```

### 🌞 Démarrer le service NGINX

```
[toto@node1 ~]$ sudo systemctl start nginx
```

### 🌞 Déterminer sur quel port tourne NGINX

```
[toto@node1 ~]$ cat /etc/nginx/nginx.conf | grep -i listen
        listen       80;
        listen       [::]:80;
```

### 🌞 Déterminer les processus liés au service NGINX

```
[toto@node1 ~]$ ps -ef | grep nginx
root       11334       1  0 14:46 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx      11335   11334  0 14:46 ?        00:00:00 nginx: worker process
```

### 🌞 Déterminer le nom de l'utilisateur qui lance NGINX

```
[toto@node1 ~]$ cat /etc/passwd | grep nginx
nginx:x:991:991:Nginx web server:/var/lib/nginx:/sbin/nologin
```

### 🌞 Test !

```
[toto@node1 ~]$ curl localhost 2> /dev/null | head -n 7
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
```

## 2. Analyser la conf de NGINX

### 🌞 Déterminer le path du fichier de configuration de NGINX

```
[toto@node1 ~]$ ls -al /etc/nginx/nginx.conf
-rw-r--r--. 1 root root 1553 Jan 30 14:51 /etc/nginx/nginx.conf
```

### 🌞 Trouver dans le fichier de conf

```
[toto@node1 ~]$ cat /etc/nginx/nginx.conf | grep 'server {' -A 16
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
```

```
[toto@node1 ~]$ cat /etc/nginx/nginx.conf | grep include
include /usr/share/nginx/modules/*.conf;
    include             /etc/nginx/mime.types;
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/default.d/*.conf;
```

## 3. Déployer un nouveau site web
   
### 🌞 Créer un site web

```
[toto@node1 ~]$ cat /var/www/tp3_linux/index.html
<h1>MEOW mon premier serveur web</h1>
```

### 🌞 Gérer les permissions

```
[toto@node1 ~]$ sudo chown nginx /var/www/tp3_linux/
```

### 🌞 Adapter la conf NGINX

```
[toto@node1 ~]$ sudo cat /etc/nginx/conf.d/tp3_linux.conf
server {
  # le port choisi devra être obtenu avec un 'echo $RANDOM' là encore
  listen 6100;

  root /var/www/tp3_linux;
}
```

### 🌞 Visitez votre super site web

```
[toto@node1 ~]$ curl localhost:6100
<h1>MEOW mon premier serveur web</h1>
```

# III. Your own services

## 2. Analyse des services existants

### 🌞 Afficher le fichier de service SSH

```

```

### 🌞 Afficher le fichier de service NGINX

```

```

## 3. Création de service
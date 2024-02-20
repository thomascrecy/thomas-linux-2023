# TP4 : Real services

# Partie 1 : Partitionnement du serveur de stockage

### 🌞 Partitionner le disque à l'aide de LVM

- créer un physical volume (PV) :
```
[toto@storage ~]$ sudo pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
[toto@storage ~]$ sudo pvcreate /dev/sdc
  Physical volume "/dev/sdc" successfully created.
[toto@storage ~]$ sudo pvs
  PV         VG Fmt  Attr PSize PFree
  /dev/sdb      lvm2 ---  2.00g 2.00g
  /dev/sdc      lvm2 ---  2.00g 2.00g
```
- créer un nouveau volume group (VG)
```
[toto@storage ~]$ sudo vgcreate storage /dev/sdb
  Volume group "storage" successfully created
[toto@storage ~]$ sudo vgextend storage /dev/sdc
  Volume group "storage" successfully extended
[toto@storage ~]$ sudo vgs
  VG      #PV #LV #SN Attr   VSize VFree
  storage   2   0   0 wz--n- 3.99g 3.99g
```
- créer un nouveau logical volume (LV) : ce sera la partition utilisable
```
[toto@storage ~]$ sudo lvcreate -l 100%FREE storage -n LVstorage
  Logical volume "LVstorage" created.
[toto@storage ~]$ sudo lvs
  LV        VG      Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  LVstorage storage -wi-a----- 3.99g
```

### 🌞 Formater la partition

```
[toto@storage ~]$ sudo mkfs -t ext4 /dev/storage/LVstorage
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 1046528 4k blocks and 261632 inodes
Filesystem UUID: 6f47ab39-46a8-4473-a3ff-9260450591af
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

### 🌞 Monter la partition

- montage de la partition (avec la commande mount)
```
[toto@storage ~]$ sudo mkdir /mnt/storage1
[toto@storage ~]$ sudo mount /dev/storage/LVstorage /mnt/storage1/
[toto@storage ~]$ df -h
Filesystem                     Size  Used Avail Use% Mounted on
devtmpfs                       4.0M     0  4.0M   0% /dev
tmpfs                          379M     0  379M   0% /dev/shm
tmpfs                          152M  3.0M  149M   2% /run
/dev/mapper/rl-root            6.2G  1.4G  4.8G  23% /
/dev/sda1                     1014M  335M  680M  33% /boot
tmpfs                           76M     0   76M   0% /run/user/1000
/dev/mapper/storage-LVstorage  3.9G   24K  3.7G   1% /mnt/storage1
```
- prouvez que vous pouvez lire et écrire des données sur cette partition
```
[toto@storage ~]$ df -h
Filesystem                     Size  Used Avail Use% Mounted on
devtmpfs                       4.0M     0  4.0M   0% /dev
tmpfs                          379M     0  379M   0% /dev/shm
tmpfs                          152M  3.0M  149M   2% /run
/dev/mapper/rl-root            6.2G  1.4G  4.8G  23% /
/dev/sda1                     1014M  335M  680M  33% /boot
tmpfs                           76M     0   76M   0% /run/user/1000
/dev/mapper/storage-LVstorage  3.9G   32K  3.7G   1% /mnt/storage1
[toto@storage ~]$ sudo dd if=/dev/zero of=/mnt/storage1/bugfile bs=4M count=50
50+0 records in
50+0 records out
209715200 bytes (210 MB, 200 MiB) copied, 5.47667 s, 38.3 MB/s
[toto@storage ~]$ df -h
Filesystem                     Size  Used Avail Use% Mounted on
devtmpfs                       4.0M     0  4.0M   0% /dev
tmpfs                          379M     0  379M   0% /dev/shm
tmpfs                          152M  3.0M  149M   2% /run
/dev/mapper/rl-root            6.2G  1.4G  4.8G  23% /
/dev/sda1                     1014M  335M  680M  33% /boot
tmpfs                           76M     0   76M   0% /run/user/1000
/dev/mapper/storage-LVstorage  3.9G  201M  3.5G   6% /mnt/storage1
[toto@storage ~]$
```

```
[toto@storage ~]$ sudo nano /etc/fstab
[toto@storage ~]$ sudo umount /mnt/storage1/
[toto@storage ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount: /mnt/storage1 does not contain SELinux labels.
       You just mounted a file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
/mnt/storage1            : successfully mounted
[toto@storage ~]$
```

# Partie 2 : Serveur de partage de fichiers

### 🌞 Donnez les commandes réalisées sur le serveur NFS storage.tp4.linux

- /etc/exports
```
[toto@storage ~]$ sudo cat /etc/exports
[sudo] password for toto:
/mnt/storage1/storage/site_web_1/ 10.4.1.16(rw,sync,no_subtree_check)
/mnt/storage1/storage/site_web_2/ 10.4.1.16(rw,sync,no_subtree_check)
/home 10.4.1.16(rw,sync,no_root_squash,no_subtree_check)
```

```
[toto@storage ~]$ sudo systemctl enable nfs-server
[toto@storage ~]$ sudo systemctl start nfs-server
[toto@storage ~]$ sudo systemctl status nfs-server
● nfs-server.service - NFS server and services
     Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; enabled; preset: disabled)
    Drop-In: /run/systemd/generator/nfs-server.service.d
             └─order-with-mounts.conf
     Active: active (exited) since Tue 2024-02-20 14:03:50 CET; 8min ago
    Process: 1671 ExecStartPre=/usr/sbin/exportfs -r (code=exited, status=0/SUCCESS)
    Process: 1672 ExecStart=/usr/sbin/rpc.nfsd (code=exited, status=0/SUCCESS)
    Process: 1685 ExecStart=/bin/sh -c if systemctl -q is-active gssproxy; then systemctl reload gss>
   Main PID: 1685 (code=exited, status=0/SUCCESS)
        CPU: 17ms

Feb 20 14:03:49 storage.tp4.linux systemd[1]: Starting NFS server and services...
Feb 20 14:03:50 storage.tp4.linux systemd[1]: Finished NFS server and services.
lines 1-13/13 (END)
```

```
[toto@storage ~]$ sudo firewall-cmd --permanent --list-all | grep services
  services: cockpit dhcpv6-client ssh
[toto@storage ~]$ sudo firewall-cmd --permanent --add-service=nfs
success
[toto@storage ~]$ sudo firewall-cmd --permanent --add-service=mountd
success
[toto@storage ~]$ sudo firewall-cmd --permanent --add-service=rpc-bind
success
[toto@storage ~]$ sudo firewall-cmd --reload
success
[toto@storage ~]$ sudo firewall-cmd --permanent --list-all | grep services
  services: cockpit dhcpv6-client mountd nfs rpc-bind ssh
```

```
[toto@storage ~]$ sudo chown nobody /mnt/storage1/storage/site_web_1
[toto@storage ~]$ sudo chown nobody /mnt/storage1/storage/site_web_2
```

### 🌞 Donnez les commandes réalisées sur le client NFS web.tp4.linux

- /etc/fstab
```
[toto@web ~]$ sudo cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Mon Oct 23 13:18:45 2023
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=66e49cfe-ddad-4118-a623-37c98d1c33c4 /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0
10.4.1.17:/mnt/storage1/storage/site_web_1 /var/www/site_web_1 nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
10.4.1.17:/mnt/storage1/storage/site_web_2 /var/www/site_web_2 nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```

```
[toto@web ~]$ sudo mkdir -p /var/www/site_web_1
[toto@web ~]$ sudo mkdir -p /var/www/site_web_2
[toto@web ~]$ sudo mount 10.4.1.17:/mnt/storage1/storage/site_web_1 /var/www/site_web_1
[toto@web ~]$ sudo mount 10.4.1.17:/mnt/storage1/storage/site_web_2 /var/www/site_web_2
[toto@web ~]$ df -h
Filesystem                                  Size  Used Avail Use% Mounted on
devtmpfs                                    4.0M     0  4.0M   0% /dev
tmpfs                                       379M     0  379M   0% /dev/shm
tmpfs                                       152M  3.0M  149M   2% /run
/dev/mapper/rl-root                         6.2G  1.4G  4.8G  23% /
/dev/sda1                                  1014M  335M  680M  33% /boot
tmpfs                                        76M     0   76M   0% /run/user/1000
10.4.1.17:/mnt/storage1/storage/site_web_1  3.9G  200M  3.5G   6% /var/www/site_web_1
10.4.1.17:/mnt/storage1/storage/site_web_2  3.9G  200M  3.5G   6% /var/www/site_web_2
```

# Partie 3 : Serveur web

## 2. Install

### 🌞 Installez NGINX

```
[toto@web ~]$ sudo dnf install nginx
```

## 3. Analyse

### 🌞 Analysez le service NGINX


- ps
```
[toto@web ~]$ ps aux | grep nginx
root        1647  0.0  0.1  10112   956 ?        Ss   14:20   0:00 nginx: master process /usr/sbin/nginx
nginx       1648  0.0  0.6  13912  4972 ?        S    14:20   0:00 nginx: worker process
toto        1659  0.0  0.2   6408  2264 pts/0    S+   14:22   0:00 grep --color=auto nginx
```

- ss
```
[toto@web ~]$ sudo ss -antpl | grep nginx
[sudo] password for toto:
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=1648,fd=6),("nginx",pid=1647,fd=6))
LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=1648,fd=7),("nginx",pid=1647,fd=7))
```

- racine web
```
[toto@web ~]$ cat /etc/nginx/nginx.conf | grep root
        root         /usr/share/nginx/html;
#        root         /usr/share/nginx/html;
```
 
```
[toto@web ~]$ ls -ld  /usr/share/nginx/html/
drwxr-xr-x. 3 root root 143 Feb 20 14:18 /usr/share/nginx/html/
```

## 4. Visite du service web

### 🌞 Configurez le firewall pour autoriser le trafic vers le service NGINX

```
[toto@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[toto@web ~]$ sudo firewall-cmd --reload
success
[toto@web ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: cockpit dhcpv6-client ssh
  ports: 80/tcp
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

### 🌞 Accéder au site web

```
[toto@web ~]$ curl http://10.4.1.16:80
<!doctype html>
<html>
  <head>
  ........
```

### 🌞 Vérifier les logs d'accès

```
[toto@web nginx]$ tail -n3 /var/log/nginx/access.log
10.4.1.1 - - [20/Feb/2024:14:34:10 +0100] "GET /poweredby.png HTTP/1.1" 200 368 "http://10.4.1.16/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" "-"
10.4.1.1 - - [20/Feb/2024:14:34:11 +0100] "GET /favicon.ico HTTP/1.1" 404 3332 "http://10.4.1.16/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" "-"
10.4.1.16 - - [20/Feb/2024:14:35:01 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.76.1" "-"
```

## 5. Modif de la conf du serveur web

### 🌞 Changer le port d'écoute

```
[toto@web nginx]$  sudo ss -antpl | grep nginx
LISTEN 0      511          0.0.0.0:8080      0.0.0.0:*    users:(("nginx",pid=1745,fd=6),("nginx",pid=1744,fd=6))
LISTEN 0      511             [::]:8080         [::]:*    users:(("nginx",pid=1745,fd=7),("nginx",pid=1744,fd=7))
```

```
[toto@web nginx]$ sudo firewall-cmd --add-port=8080/tcp --permanent
success
[toto@web nginx]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[toto@web nginx]$ sudo firewall-cmd --reload
success
[toto@web nginx]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: cockpit dhcpv6-client ssh
  ports: 8080/tcp
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

```
[toto@web ~]$ curl http://10.4.1.16:8080
<!doctype html>
<html>
  <head>
  ........
```

### 🌞 Changer l'utilisateur qui lance le service

```
[toto@web ~]$ sudo cat /etc/nginx/nginx.conf | grep user
user web;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
```

```
[toto@web ~]$ ps aux | grep nginx
root        1810  0.0  0.1  10112   952 ?        Ss   14:49   0:00 nginx: master process /usr/sbin/nginx
web         1811  0.0  0.6  13912  4976 ?        S    14:49   0:00 nginx: worker process
toto        1813  0.0  0.2   6408  2296 pts/0    S+   14:49   0:00 grep --color=auto nginx
```

### 🌞 Changer l'emplacement de la racine Web

```
[toto@web ~]$ sudo cat /var/www/site_web_1/index.html
texte bidon
```

```
[toto@web ~]$ sudo nano /etc/nginx/nginx.conf
[toto@web ~]$ sudo cat /etc/nginx/nginx.conf | grep root
        root         /var/www/site_web_1;
#        root         /usr/share/nginx/html;
[toto@web ~]$ sudo systemctl restart nginx
[toto@web ~]$ curl http://10.4.1.16:8080
texte bidon
```

## 6. Deux sites web sur un seul serveur

### 🌞 Repérez dans le fichier de conf

```
[toto@web ~]$ sudo cat /etc/nginx/nginx.conf | grep conf.d
    # Load modular configuration files from the /etc/nginx/conf.d directory.
    include /etc/nginx/conf.d/*.conf;
```

### 🌞 Créez le fichier de configuration pour le premier site

```
[toto@web ~]$ sudo cat /etc/nginx/nginx.conf | grep server
# Settings for a TLS enabled server.
#    server {
#        server_name  _;
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_prefer_server_ciphers on;
#        # Load configuration files for the default server block.
```

```
[toto@web ~]$ sudo cat /etc/nginx/conf.d/site_web_1.conf
 server {
        listen       8080;
        listen       [::]:8080;
        server_name  _;
        root         /var/www/site_web_1;

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

### 🌞 Créez le fichier de configuration pour le deuxième site

```
[toto@web ~]$ sudo cat /etc/nginx/conf.d/site_web_2.conf
 server {
        listen       8888;
        listen       [::]:8888;
        server_name  _;
        root         /var/www/site_web_2;

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

### 🌞 Prouvez que les deux sites sont disponibles

- site_web_1
```
[toto@web ~]$ cat /var/www/site_web_1/index.html
texte bidon
```

```
[toto@web ~]$ cat /etc/nginx/conf.d/site_web_1.conf
 server {
        listen       8080;
        listen       [::]:8080;
        server_name  _;
        root         /var/www/site_web_1;

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
[toto@web ~]$ curl http://10.4.1.16:8080
texte bidon
```

- site_web_2

```
[toto@web ~]$ cat /var/www/site_web_2/index.html
texte exceptionnel
```

```
[toto@web ~]$ cat /etc/nginx/conf.d/site_web_2.conf
 server {
        listen       8888;
        listen       [::]:8888;
        server_name  _;
        root         /var/www/site_web_2;

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
[toto@web ~]$ curl http://10.4.1.16:8888
texte exceptionnel
```

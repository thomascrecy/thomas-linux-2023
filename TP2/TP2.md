# TP2 : Appréhension d'un système Linux

# Partie 1 : Files and users

## I. Fichiers

## 1. Find me

### 🌞 Trouver le chemin vers le répertoire personnel de votre utilisateur
```
[toto@localhost ~]$ cd /home/toto/
```

### 🌞 Trouver le chemin du fichier de logs SSH

```
[toto@localhost ~]$ sudo cat /var/log/secure
Oct 23 15:26:37 localhost sshd[785]: Server listening on 0.0.0.0 port 22.
Oct 23 15:26:37 localhost sshd[785]: Server listening on :: port 22.
Oct 23 15:27:00 localhost systemd[818]: pam_unix(systemd-user:session): session opened for user toto(uid=1000) by (uid=0)
Oct 23 15:27:00 localhost login[717]: pam_unix(login:session): session opened for user toto(uid=1000) by LOGIN(uid=0)
Oct 23 15:27:00 localhost login[717]: LOGIN ON tty1 BY toto
Oct 23 15:31:14 localhost sudo[4242]:    toto : TTY=tty1 ; PWD=/home/toto ; USER=root ; COMMAND=/sbin/setenforce 0
Oct 23 15:31:14 localhost sudo[4242]: pam_unix(sudo:session): session opened for user root(uid=0) by toto(uid=1000)
Oct 23 15:31:14 localhost sudo[4242]: pam_unix(sudo:session): session closed for user root
Oct 23 15:32:03 localhost sudo[4249]:    toto : TTY=tty1 ; PWD=/home/toto ; USER=root ; COMMAND=/bin/dnf install -y nano
Oct 23 15:32:03 localhost sudo[4249]: pam_unix(sudo:session): session opened for user root(uid=0) by toto(uid=1000)
Oct 23 15:33:16 localhost sudo[4249]: pam_unix(sudo:session): session closed for user root
Oct 23 15:33:30 localhost sudo[13765]:    toto : TTY=tty1 ; PWD=/home/toto ; USER=root ; COMMAND=/bin/nano /etc/selinux/config
Oct 23 15:33:30 localhost sudo[13765]: pam_unix(sudo:session): session opened for user root(uid=0) by toto(uid=1000)
Oct 23 15:34:49 localhost sudo[13765]: pam_unix(sudo:session): session closed for user root
Oct 23 15:36:47 localhost sudo[13771]:    toto : TTY=tty1 ; PWD=/home/toto ; USER=root ; COMMAND=/bin/dnf install -y python3 bind-utils nmap nc tcdump vim traceroute nano dhclient
Oct 23 15:36:47 localhost sudo[13771]: pam_unix(sudo:session): session opened for user root(uid=0) by toto(uid=1000)
Oct 23 15:36:47 localhost sudo[13771]: pam_unix(sudo:session): session closed for user root
Oct 23 15:37:01 localhost sudo[13774]:    toto : TTY=tty1 ; PWD=/home/toto ; USER=root ; COMMAND=/bin/dnf install -y python3 bind-utils nmap nc tcpdump vim traceroute nano dhclient
Oct 23 15:37:01 localhost sudo[13774]: pam_unix(sudo:session): session opened for user root(uid=0) by toto(uid=1000)
Oct 23 15:37:32 localhost groupadd[13814]: group added to /etc/group: name=tcpdump, GID=72
Oct 23 15:37:32 localhost groupadd[13814]: group added to /etc/gshadow: name=tcpdump
Oct 23 15:37:32 localhost groupadd[13814]: new group: name=tcpdump, GID=72
Oct 23 15:37:32 localhost useradd[13821]: new user: name=tcpdump, UID=72, GID=72, home=/, shell=/sbin/nologin, from=none
Oct 23 15:37:34 localhost sudo[13774]: pam_unix(sudo:session): session closed for user root
Jan 22 15:07:48 localhost sshd[682]: Server listening on 0.0.0.0 port 22.
Jan 22 15:07:48 localhost sshd[682]: Server listening on :: port 22.
Jan 22 15:08:23 localhost systemd[1266]: pam_unix(systemd-user:session): session opened for user toto(uid=1000) by (uid=0)
Jan 22 15:08:23 localhost login[690]: pam_unix(login:session): session opened for user toto(uid=1000) by LOGIN(uid=0)
Jan 22 15:08:23 localhost login[690]: LOGIN ON tty1 BY toto
Jan 22 15:17:16 localhost sshd[682]: Server listening on 0.0.0.0 port 22.
Jan 22 15:17:16 localhost sshd[682]: Server listening on :: port 22.
Jan 22 15:20:09 localhost sshd[684]: Server listening on 0.0.0.0 port 22.
Jan 22 15:20:09 localhost sshd[684]: Server listening on :: port 22.
Jan 22 15:20:16 localhost systemd[793]: pam_unix(systemd-user:session): session opened for user toto(uid=1000) by (uid=0)
Jan 22 15:20:16 localhost login[690]: pam_unix(login:session): session opened for user toto(uid=1000) by LOGIN(uid=0)
Jan 22 15:20:16 localhost login[690]: LOGIN ON tty1 BY toto
Jan 22 15:20:57 localhost sshd[828]: Accepted password for toto from 10.0.2.2 port 54396 ssh2
Jan 22 15:20:57 localhost sshd[828]: pam_unix(sshd:session): session opened for user toto(uid=1000) by (uid=0)
Jan 22 15:28:09 localhost sudo[1349]:    toto : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/bin/cat secure
Jan 22 15:28:09 localhost sudo[1349]: pam_unix(sudo:session): session opened for user root(uid=0) by toto(uid=1000)
Jan 22 15:28:09 localhost sudo[1349]: pam_unix(sudo:session): session closed for user root
```

### 🌞 Trouver le chemin du fichier de configuration du serveur SSH

```
[toto@localhost ~]$ sudo cat /etc/ssh/sshd_config
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

## II. Users

## 1. Nouveau user

### 🌞 Créer un nouvel utilisateur

```
[toto@localhost home]$ ls
toto
[toto@localhost home]$ sudo useradd -m -d /home/papier_alu marmotte
[toto@localhost home]$ ls
papier_alu  toto
[toto@localhost home]$ sudo passwd marmotte
Changing password for user marmotte.
New password:
BAD PASSWORD: The password fails the dictionary check - it is based on a dictionary word
Retype new password:
passwd: all authentication tokens updated successfully.
```

## 2. Infos enregistrées par le système

### 🌞 Prouver que cet utilisateur a été créé

```
[toto@localhost home]$ cat /etc/passwd | grep marmotte
marmotte:x:1001:1001::/home/papier_alu:/bin/bash
```

### 🌞 Déterminer le hash du password de l'utilisateur marmotte

```
[toto@localhost home]$ sudo cat /etc/shadow | grep marmotte
[sudo] password for toto:
marmotte:$6$Y3IVCikmtDyH.sf8$mIkALTAH6fnQGRWY.sAnGEUJHqu9ZLQgnTMbCOzo9BfQo19mtCMZFrQ6pHAvwqjzqZtYYZjR1vite87PRfqzj1:19744:0:99999:7:::
```

## 3. Connexion sur le nouvel utilisateur

### 🌞 Tapez une commande pour vous déconnecter : fermer votre session utilisateur

```
[toto@localhost ~]$ logout
Connection to 10.2.1.10 closed.
```

### 🌞 Assurez-vous que vous pouvez vous connecter en tant que l'utilisateur marmotte

```
PS C:\Users\crecy> ssh -p 3022 marmotte@10.2.1.10
marmotte@10.2.1.10's password:
[marmotte@localhost ~]$
```

# Partie 2 : Programmes et paquets

## I. Programmes et processus

## 1. Run then kill

### 🌞 Lancer un processus sleep

```
[toto@localhost ~]$ sleep 1000
```

```
[toto@localhost ~]$ ps aux | grep 1544
toto        1544  0.0  0.1   5584  1016 pts/0    S+   15:58   0:00 sleep 1000
toto        1549  0.0  0.2   6408  2304 pts/1    S+   15:59   0:00 grep --color=auto 1544
```

🌞 Terminez le processus sleep depuis le deuxième terminal

```
[toto@localhost ~]$ kill 1544
```
```
[toto@localhost ~]$ sleep 1000
Terminated
[toto@localhost ~]$
```

## 2. Tâche de fond

### 🌞 Lancer un nouveau processus sleep, mais en tâche de fond

```
[toto@localhost ~]$ sleep 1000 &
[1] 1570
[toto@localhost ~]$
```

### 🌞 Visualisez la commande en tâche de fond

```
[toto@localhost ~]$ ps -e | grep 1570
   1570 pts/0    00:00:00 sleep
```

## 3. Find paths

### 🌞 Trouver le chemin où est stocké le programme sleep

```
[toto@localhost ~]$ sudo find / -name "sleep"
/usr/bin/sleep
```

```
[toto@localhost ~]$ ls -al /usr/bin/ | grep sleep
-rwxr-xr-x.  1 root root   36312 Apr 24  2023 sleep
```

### 🌞 Tant qu'on est à chercher des chemins : trouver les chemins vers tous les fichiers qui s'appellent .bashrc

```
[toto@localhost ~]$ sudo find / -name ".bashrc"
[sudo] password for toto:
/etc/skel/.bashrc
/root/.bashrc
/home/toto/.bashrc
/home/papier_alu/.bashrc
```

## 4. La variable PATH

### 🌞 Vérifier que

```
[toto@localhost ~]$ which sleep
/usr/bin/sleep
[toto@localhost ~]$ which ssh
/usr/bin/ssh
[toto@localhost ~]$ which ping
/usr/bin/ping
```

# II. Paquets

### 🌞 Installer le paquet firefox

```
[toto@localhost ~]$ sudo dnf install git
```

### 🌞 Utiliser une commande pour lancer Firefox

```
[toto@localhost ~]$ which git
/usr/bin/git
```

### 🌞 Installer le paquet nginx

```
[toto@localhost ~]$ sudo dnf install nginx
```

### 🌞 Déterminer

```
[toto@localhost ~]$ sudo ls -al /var/log/nginx/
total 4
drwx--x--x. 2 root root    6 Oct 16 20:00 .
drwxr-xr-x. 8 root root 4096 Jan 22 16:21 ..
```

```
[toto@localhost ~]$ ls -al /etc/nginx/
total 84
drwxr-xr-x.  4 root root 4096 Jan 22 16:21 .
drwxr-xr-x. 78 root root 8192 Jan 22 16:21 ..
drwxr-xr-x.  2 root root    6 Oct 16 20:00 conf.d
drwxr-xr-x.  2 root root    6 Oct 16 20:00 default.d
-rw-r--r--.  1 root root 1077 Oct 16 20:00 fastcgi.conf
-rw-r--r--.  1 root root 1077 Oct 16 20:00 fastcgi.conf.default
-rw-r--r--.  1 root root 1007 Oct 16 20:00 fastcgi_params
-rw-r--r--.  1 root root 1007 Oct 16 20:00 fastcgi_params.default
-rw-r--r--.  1 root root 2837 Oct 16 20:00 koi-utf
-rw-r--r--.  1 root root 2223 Oct 16 20:00 koi-win
-rw-r--r--.  1 root root 5231 Oct 16 20:00 mime.types
-rw-r--r--.  1 root root 5231 Oct 16 20:00 mime.types.default
-rw-r--r--.  1 root root 2334 Oct 16 20:00 nginx.conf
-rw-r--r--.  1 root root 2656 Oct 16 20:00 nginx.conf.default
-rw-r--r--.  1 root root  636 Oct 16 20:00 scgi_params
-rw-r--r--.  1 root root  636 Oct 16 20:00 scgi_params.default
-rw-r--r--.  1 root root  664 Oct 16 20:00 uwsgi_params
-rw-r--r--.  1 root root  664 Oct 16 20:00 uwsgi_params.default
-rw-r--r--.  1 root root 3610 Oct 16 20:00 win-utf
```

### 🌞 Mais aussi déterminer...

```
[toto@localhost yum.repos.d]$ grep -nri -E '^mirrorlist'
```

# Partie 3 : Poupée russe

### 🌞 Récupérer le fichier meow

```
[toto@localhost ~]$ wget https://gitlab.com/it4lik/b1-linux-2023/-/blob/master/tp/2/meow
```

### 🌞 Trouver le dossier dawa/

```
[toto@localhost ~]$ ls
dawa  meow.rar  meow.tar  meow.zip
```

### 🌞 Dans le dossier dawa/, déterminer le chemin vers

### le seul fichier de 15Mo

```
[toto@localhost ~]$ find dawa/ -type f -size 15M
dawa/folder31/19/file39
```

### le seul fichier qui ne contient que des 7

```
[toto@localhost ~]$ grep -rl '^7*$' dawa/
dawa/folder31/19/file39
```

### le seul fichier qui est nommé cookie

```
[toto@localhost ~]$ find dawa/ -name cookie
dawa/folder14/25/cookie
```

### le seul fichier caché (un fichier caché c'est juste un fichier dont le nom commence par un .)

```
[toto@localhost ~]$ find dawa/ -name '.*'
dawa/folder32/14/.hidden_file
```

### le seul fichier qui date de 2014

```
[toto@localhost dawa]$ find . -type f -mtime +30
./folder36/40/file43
```

### le seul fichier qui a 5 dossiers-parents

```
[toto@localhost ~]$ find dawa/ -mindepth 5 -maxdepth 6 -type f
dawa/folder37/45/23/43/54/file43
```
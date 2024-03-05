# TP 5 : We do a little scripting

# Partie 1 : Script carte d'identité

### 📁 Fichier /srv/idcard/idcard.sh

### 🌞 Vous fournirez dans le compte-rendu Markdown, en plus du fichier, un exemple d'exécution avec une sortie

```
[toto@localhost ~]$ sudo /srv/idcard/idcard.sh
Machine name: localhost.
OS: Rocky Linux and kernel version is 5.14.0-362.18.1.el9_3.0.1.x86_64
IP: 10.0.2.15
RAM: 479 memory available on 757
Disk: 5031164 space left
Top 5 processes by RAM usage:
  - python3
  - NetworkManager
  - systemd
  - systemd
  - systemd
Listening ports :
  - 323 udp : chronyd
  - 22 tcp : sshd
PATH directories:
  - /sbin
  - /bin
  - /usr/sbin
  - /usr/bin
Here is your random cat (jpg file): https://cdn2.thecatapi.com/images/cf0.jpg
```

## Partie 2 : Script youtube-dl

## 1. Premier script youtube-dl

### 📁 Le script /srv/yt/yt.sh

### 📁 Le fichier de log /var/log/yt/download.log, avec au moins quelques lignes

```
[toto@localhost ~]$ sudo cat /var/log/yt/download.log
[24/03/04 16:44:50] Video https://www.youtube.com/watch?v=sNx57atloH8 was downloaded. File path : /srv/yt/downloads/tomato anxiety
```

### 🌞 Vous fournirez dans le compte-rendu, en plus du fichier, un exemple d'exécution avec une sortie

```
[toto@localhost ~]$ /srv/yt/yt.sh https://www.youtube.com/watch?v=sNx57atloH8
Video https://www.youtube.com/watch?v=sNx57atloH8 was downloaded.
File path : /srv/yt/downloads/tomato anxiety
```

## 2. MAKE IT A SERVICE
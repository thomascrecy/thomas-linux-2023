# TP 5 : We do a little scripting

# Partie 1 : Script carte d'identité

### 📁 Fichier /srv/idcard/idcard.sh

```
[toto@localhost ~]$ sudo cat /srv/idcard/idcard.sh
#!/bin/bash
# Script TP5

echo "Machine name: $(hostnamectl hostname)."
source /etc/os-release
echo "OS: $NAME and kernel version is $(uname -r)"
echo "IP: $((hostname -I) | awk '{print $1}')"
echo "RAM: $(free -m | awk '/Mem:/ {print $7}') memory available on $(free -m | awk '/Mem:/ {print $2}')"
echo "Disk: $(df | awk '/dev\/mapper\/rl-root/ {print $4}') space left"
echo "Top 5 processes by RAM usage:"
echo "$(ps -eo command= --sort=-%mem | head -n5 | awk -F/ '{print $4}' | awk '{print "  - " $1}')"
echo "Listening ports:"
echo "PATH directories:"
echo "$(echo $PATH | tr ':' '\n' | sed 's/^/  - /')"
echo "Here is your random cat (jpg file): $(curl -s https://api.thecatapi.com/v1/images/search?api_key=${1} | cut -d',' -f2 | cut -d'"' -f4)"
```

### 🌞 Vous fournirez dans le compte-rendu Markdown, en plus du fichier, un exemple d'exécution avec une sortie

```
[toto@localhost ~]$ /srv/idcard/idcard.sh
Machine name: localhost.
OS: Rocky Linux and kernel version is 5.14.0-362.18.1.el9_3.0.1.x86_64
IP: 10.0.2.15
RAM: 503 memory available on 757
Disk: 5033564 space left
Top 5 processes by RAM usage:
  - python3
  - NetworkManager
  - systemd
  - systemd
  - systemd
Listening ports:
PATH directories:
  - /home/toto/.local/bin
  - /home/toto/bin
  - /usr/local/bin
  - /usr/bin
  - /usr/local/sbin
  - /usr/sbin
Here is your random cat (jpg file): https://cdn2.thecatapi.com/images/b1o.jpg
```

## Partie 2 : Script youtube-dl

## 1. Premier script youtube-dl

### 📁 Le script /srv/yt/yt.sh

```
#!/bin/bash

dossier_dl="downloads"
dossier_log="/var/log/yt"
dossier_log_dl="download.log"
description_log="description"

localDr=$(dirname $(realpath "$0"))
downloadFile="${localDr}/${dossier_dl}"

videoName=$(youtube-dl --skip-download --get-title --no-warnings $1)
videoDescription=$(youtube-dl --skip-download --get-description --no-warnings $1)

VidsDir="${downloadFile}/${videoName}"
mkdir -p "${VidsDir}"
echo $videoDescription > "${VidsDir}/${description_log}"

youtube-dl -f mp4 -o "${VidsDir}/%(title)s-%(id)s.%(ext)s" --no-warnings $1 > /dev/null

echo "Video ${1} was downloaded."
echo "File path : ${VidsDir}"

if [ ! -d "${dossier_log}" ]; then
    exit
fi

currentDate=$(date +"%y/%m/%d %H:%M:%S")
echo "[${currentDate}] Video ${1} was downloaded."
echo "File path : ${VidsDir}" >> "${dossier_log}/${dossier_log_dl}"
```

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
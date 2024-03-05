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
#!/bin/bash
# Script TP5

if [[ ! $(id -un) == 'root'  ]] ; then
  echo "tu n'es pas root. Exit"
  exit 1
fi

echo "Machine name: $(hostnamectl hostname)."
source /etc/os-release
echo "OS: $NAME and kernel version is $(uname -r)"
echo "IP: $((hostname -I) | awk '{print $1}')"
echo "RAM: $(free -m | awk '/Mem:/ {print $7}') memory available on $(free -m | awk '/Mem:/ {print $2}')"
echo "Disk: $(df | awk '/dev\/mapper\/rl-root/ {print $4}') space left"
echo "Top 5 processes by RAM usage:"
echo "$(ps -eo command= --sort=-%mem | head -n5 | awk -F/ '{print $4}' | awk '{print "  - " $1}')"
echo "Listening ports :"
while read -r onsenfou; do

  protocol=$(awk '{print $1}' <<< "${onsenfou}")
  port=$(echo $onsenfou | tr -s ' ' | cut -d':' -f2 | cut -d' ' -f1)
  process=$(echo $onsenfou | tr -s ' ' | cut -d'"' -f2)
  echo "  - ${port} ${protocol} : ${process}"

done <<< "$(ss -lntup4H)"
echo "PATH directories:"
echo "$(echo $PATH | tr ':' '\n' | sed 's/^/  - /')"
echo "Here is your random cat (jpg file): $(curl -s https://api.thecatapi.com/v1/images/search?api_key=${1} | cut -d',' ->
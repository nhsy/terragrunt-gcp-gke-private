#!/bin/bash

set -euo pipefail

#exec >> /var/log/metadata_startup.log 2>&1
exec &> >(tee -a /var/log/metadata_startup.log)
echo "metadata_startup_start"

if [ ! -f /var/log/metadata_startup_completed ];then
  apt install -y privoxy

  sed -i 's/listen-address  127.0.0.1:8118/listen-address  0.0.0.0:8080/g' /etc/privoxy/config

  systemctl restart privoxy

  touch /var/log/metadata_startup_completed
else
  echo "Skipping startup script"
fi

echo "metadata_startup_end"

#!/bin/sh

sudo apt update
sudo apt install -y nfs-common

sudo mkdir -p /mnt/share
sudo mount -t nfs4 "${SHARE_EXPORT_PATH}" /mnt/share
echo "${SHARE_EXPORT_PATH} /mnt/share nfs nfsvers=4 defaults,noauto 0 0" | sudo tee -a /etc/fstab
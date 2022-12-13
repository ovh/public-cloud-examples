#!/bin/sh 
  
# Inhib Cloud-init network configuration
echo \"network: {config: disabled}\" > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg

# Build new netplan (remove cloud-init one)
rm /etc/netplan/*.yaml

cat <<EOF > /etc/netplan/config.yaml
network:  
  version: 2
  ethernets:
    ens3:
      dhcp4: true
    ens4:
      addresses: [${bastionIP}/24]
      dhcp4: false
      dhcp6: false
      routes:
      - to: 192.168.0.0/16
        via: ${bGateway}
      - to: 192.168.10.0/24
        via: ${rtrIp}
      - to: 192.168.20.0/24
        via: ${bGateway}
      - to: 192.168.30.0/24
        via: ${bGateway}
EOF
netplan apply

# Firewall - ufw
# only accept SSH

ufw default deny incoming
ufw default allow outgoing
ufw allow 22
ufw enable

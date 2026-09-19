#!/bin/sh

SETCONF=/usr/Firewall/sbin/setconf
CF=/usr/Firewall/ConfigFiles
SBIN=/usr/Firewall/sbin
GLOBAL=/usr/Firewall/System/global

SERIAL_NUMBER="${SERIAL_NUMBER}"

PASSWORD="${PASSWORD}"

WAN_IP="${WAN_IP}"
WAN_MASK="${WAN_MASK}"
WAN_GW="${WAN_GW}"

LAN_IP="${LAN_IP}"
LAN_MASK="${LAN_MASK}"

HA_IP="${HA_IP}"
HA_MASK="${HA_MASK}"

ADMIN_CLIENT_IP="${ADMIN_CLIENT_IP}"

HA_ID="${HA_ID}"
HA_PRIMARY_IP="${HA_PRIMARY_IP}"

$SETCONF $CF/system Console State Serial
$SBIN/enconsole

# Configure password
$SBIN/fwpasswd -p $PASSWORD

$SETCONF $GLOBAL Options SystemName "STORMSHIELD"
$SETCONF $GLOBAL Options SystemNodeName "HA-"$HA_ID
$SBIN/enservice

#chsh -s /bin/sh admin

# Add default gateway and admin IP ACL
echo '[Host]' >> /usr/Firewall/ConfigFiles/object.new
echo Firewall_out_router=$WAN_GW >> /usr/Firewall/ConfigFiles/object.new
echo admin_client=$ADMIN_CLIENT_IP >> /usr/Firewall/ConfigFiles/object.new
sed -e '1,1d' /usr/Firewall/ConfigFiles/object >> /usr/Firewall/ConfigFiles/object.new
mv /usr/Firewall/ConfigFiles/object.new /usr/Firewall/ConfigFiles/object

# WAN interface configuration
sed -e '142,149d' /usr/Firewall/ConfigFiles/network > /usr/Firewall/ConfigFiles/network.new
echo '' >> /usr/Firewall/ConfigFiles/network.new
echo '[ethernet0]' >> /usr/Firewall/ConfigFiles/network.new
echo 'State=1' >> /usr/Firewall/ConfigFiles/network.new
echo 'Name=wan' >> /usr/Firewall/ConfigFiles/network.new
echo 'Color=800040' >> /usr/Firewall/ConfigFiles/network.new
echo 'Media=0' >> /usr/Firewall/ConfigFiles/network.new
echo 'EEE=0' >> /usr/Firewall/ConfigFiles/network.new
echo Address=$WAN_IP >> /usr/Firewall/ConfigFiles/network.new
echo Mask=$WAN_MASK >> /usr/Firewall/ConfigFiles/network.new
mv /usr/Firewall/ConfigFiles/network.new /usr/Firewall/ConfigFiles/network
$SBIN/ennetwork

# LAN and HA interfaces configuration
cat << EOCONFIG > /tmp/stormshield.cfg
CONFIG NETWORK INTERFACE ADDRESS UPDATE ifname=ethernet1 address=$LAN_IP mask=$LAN_MASK addrnb=0
CONFIG NETWORK INTERFACE ADDRESS UPDATE ifname=ethernet2 address=$HA_IP mask=$HA_MASK addrnb=0
CONFIG NETWORK INTERFACE ACTIVATE
CONFIG NETWORK INTERFACE RENAME ifname=ethernet1 name=lan
CONFIG NETWORK INTERFACE RENAME ifname=ethernet2 name=ha
CONFIG NETWORK INTERFACE ACTIVATE
EOCONFIG
$SBIN/nsrpc -f -c /tmp/stormshield.cfg -l /tmp/stormshield.output admin:$PASSWORD@127.0.0.1:1300

# Create default firewall rules
cat << EOFILTER > $CF/Filter/01
[Filter]
separator color="c0c0c0" comment="Remote Management" collapse="0"
pass from admin_client to firewall_all port firewall_srv|https  # Admin from admin client IP
pass ipproto icmp type 8 code 0 proto none from admin_client to firewall_all    # Allow Ping from admin client IP
pass from admin_client on wan to Firewall_wan port ssh # Allow SSH from admin client IP
separator color="c0c0c0" comment="HA policy" collapse="0"
pass from Network_ha on ha to Firewall_ha # Allow traffic between HA interfaces
separator color="c0c0c0" comment="Default policy" collapse="0"
block from any to any   # Block all
EOFILTER
$SBIN/enfilter 01

# Enable SSH
$SETCONF $CF/system SSH State 1
$SETCONF $CF/system SSH Password 1
$SBIN/enservice

# HA configuration
if [ $HA_ID -eq 1 ]
then
    cat << EOHA > /tmp/ha.cfg
CONFIG HA CREATE password=stormshield ifname=ha Unicast=1 secure=1
CONFIG HA ACTIVATE
EOHA

$SBIN/nsrpc -f -c /tmp/ha.cfg -l /tmp/ha.output admin:$PASSWORD@127.0.0.1:1300
else
    cat << EOHA > /tmp/ha.cfg
CONFIG HA JOIN password=stormshield ip=$HA_PRIMARY_IP
CONFIG HA ACTIVATE
EOHA

(sleep 300 && $SBIN/nsrpc -f -c /tmp/ha.cfg -l /tmp/ha.output admin:$PASSWORD@127.0.0.1:1300 && sleep 60 && hasync)&
fi

# Configure licence
if [ $SERIAL_NUMBER ]
then
    cat << EOUPDATEUPLOAD > /tmp/update-upload.cfg
SYSTEM UPDATE UPLOAD < /tmp/vminit-$SERIAL_NUMBER.maj
EOUPDATEUPLOAD

    cat << EOUPDATEAPPLY > /tmp/update-activate.cfg
SYSTEM UPDATE ACTIVATE
EOUPDATEAPPLY

(while [ ! -f /tmp/vminit-$SERIAL_NUMBER.maj ]; do echo "Waiting for update file..." >> /tmp/update-upload.output && sleep 1; done && echo "Update file uploaded" >> /tmp/update-upload.output && sleep 10 && $SBIN/nsrpc -f -c /tmp/update-upload.cfg -l /tmp/update-upload.output admin:$PASSWORD@127.0.0.1:1300 && sed -i '' 's/VMSNSX00Z0000A0/'$SERIAL_NUMBER'/g' $CF/HA/hacluster && $SBIN/nsrpc -f -c /tmp/update-activate.cfg -l /tmp/update-activate.output admin:$PASSWORD@127.0.0.1:1300)&
fi
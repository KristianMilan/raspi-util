#!/bin/bash

cdir=`dirname "$0"`

mkdir -p /home/pi/openvpn/
if [ ! -f "/home/pi/openvpn/vpn.conf" ]; then
    echo "Please first upload the config file for this device to /home/pi/openvpn/vpn.conf"
    exit 1
fi
sudo apt-get install -y openvpn

sudo cp /home/pi/openvpn/vpn.conf /etc/openvpn/client/vpn.conf
sudo systemctl enable openvpn-client@vpn.service
sudo systemctl preset openvpn-client@vpn.service

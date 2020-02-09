#!/bin/bash
# Sets the hostname

if [ $# -eq 0 ]; then
    echo "No hostname supplied"
    exit 1
fi 

cdir=`dirname "$0"`
. ../common/utils.bash

echo "Setting hostname to $1"
HOSTNAME=$1

echo $HOSTNAME | sudo tee /etc/hostname
replace /etc/hosts "raspberrypi" "$HOSTNAME"
echo "Done! Settings will be applied after reboot"
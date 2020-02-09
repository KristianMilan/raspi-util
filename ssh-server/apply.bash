#!/bin/bash
#
# Applies our public keys to this device and disables password access
cdir=`dirname "$0"`
. ../common/utils.bash

mkdir -p /home/pi/.ssh/
chmod 0700 /home/pi/.ssh/
cp $cdir/res/public.txt /home/pi/.ssh/authorized_keys
chmod 0600 /home/pi/.ssh/authorized_keys

# Disable password login for pi:
replaceAppend /etc/ssh/sshd_config "^.*ChallengeResponseAuthentication.*$" "ChallengeResponseAuthentication no"
replaceAppend /etc/ssh/sshd_config "^.*PasswordAuthentication.*$" "PasswordAuthentication no"
replaceAppend /etc/ssh/sshd_config "^.*UsePAM.*$" "UsePAM no"

sudo service ssh restart
echo "Restarted SSH"
# Note a reboot will be needed to shift the "default password" warning (or, change the password...)


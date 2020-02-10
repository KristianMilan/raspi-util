#!/bin/bash

cdir=`dirname "$0"`
. ../common/utils.bash

# Remove some common packages (careful cron is going...)
# We're keeping fake-hwclock in case we need to depend on time-expiry certificates
sudo apt-get remove --purge wolfram-engine triggerhappy cron logrotate dbus dphys-swapfile xserver-common lightdm
sudo apt-get autoremove --purge

sudo apt-get install busybox-syslogd
sudo dpkg --purge rsyslog

sudo cp ./res/cmdline.txt /boot/cmdline.txt

# Move spool to tmp
sudo rm -rf  /var/spool
sudo ln -s /tmp /var/spool

# Set up resolv.conf
sudo touch /tmp/dhcpcd.resolv.conf
sudo rm /etc/resolv.conf
sudo ln -s /tmp/dhcpcd.resolv.conf /etc/resolv.conf

# Make SSH work
replaceAppend /etc/ssh/sshd_config "^.*UsePrivilegeSeparation.*$" "UsePrivilegeSeparation no"

# Make edits to fstab
# make / ro
# tmpfs /var/log tmpfs nodev,nosuid 0 0
# tmpfs /var/tmp tmpfs nodev,nosuid 0 0
# tmpfs /tmp     tmpfs nodev,nosuid 0 0
replace /etc/fstab "vfat\s*defaults\s" "vfat    defaults,ro "
replace /etc/fstab "ext4\s*defaults,noatime\s" "ext4    defaults,noatime,ro "
append1 /etc/fstab "/var/log" "tmpfs /var/log tmpfs defaults,noatime,nosuid,nodev,noexec,mode=1777 0 0"
append1 /etc/fstab "/var/tmp" "tmpfs /var/tmp tmpfs defaults,noatime,nosuid,nodev,noexec,mode=1777 0 0"
append1 /etc/fstab "\s/tmp"   "tmpfs /tmp    tmpfs defaults,noatime,nosuid,nodev,noexec,mode=1777 0 0"

echo "Done."
echo
echo "Settings take effect on next boot."
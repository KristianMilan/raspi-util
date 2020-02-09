#!/bin/bash
# Uses the system uptime to see if we have a network connection. if not, reboots...

sudo cp /home/pi/raspi-util/nonet-reboot/res/raspi-util-nonet-reboot.service /etc/systemd/system/raspi-util-nonet-reboot.service

# Now run it
sudo systemctl enable raspi-util-nonet-reboot.service
sudo systemctl start raspi-util-nonet-reboot.service

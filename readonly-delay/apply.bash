#!/bin/bash
# Makes the filesystem readonly after a short time (interim solution until we get proper read-only implemented)

sudo cp /home/pi/raspi-util/readonly-delay/res/raspi-util-readonly-delay.service /etc/systemd/system/raspi-util-readonly-delay.service

# Now run it
sudo systemctl enable raspi-util-readonly-delay.service
sudo systemctl start raspi-util-readonly-delay.service

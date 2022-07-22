#!/bin/bash

set -o errexit

grpname=${USER}

# Create udev rule
UdevFile="/etc/udev/rules.d/40-flir-spinnaker.rules"

echo "Writing the udev rules file...";

# Spinnaker Camera
echo "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"1e10\", GROUP=\"$grpname\", SYMLINK+=\"sensors/camera\"" 1>$UdevFile
echo "SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"1724\", GROUP=\"$grpname\", SYMLINK+=\"sensors/camera\"" 1>>$UdevFile

echo "Restarting udev daemon..."

/etc/init.d/udev restart
sudo udevadm control --reload-rules
sudo udevadm trigger

echo "Configuration complete."
echo "A reboot may be required on some systems for changes to take effect."
exit 0

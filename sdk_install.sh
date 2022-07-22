#!/usr/bin/env bash
echo "Start..."
export DEBIAN_FRONTEND=noninteractive
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sudo apt-get -y install expect

sudo apt-get install libavcodec58 libavformat58 \
libswscale5 libswresample3 libavutil56 libusb-1.0-0 \
libpcre2-16-0 libdouble-conversion3 libxcb-xinput0 \
libxcb-xinerama0

cd $SCRIPT_DIR/sdk/

yes | sudo ./remove_spinnaker.sh

/usr/bin/expect -c ' 

set timeout -1
spawn ./install_spinnaker.sh

match_max 100000

expect -exact "This is a script to assist with installation of the Spinnaker SDK.\r
Would you like to continue and install all the Spinnaker SDK packages?\r
\[Y/n\] \$ "

send -- "y\r"
expect -exact "\[More\] "
send -- "\r"
expect -exact "\[More\]"
send -- "\r"
expect -exact "\[More\] "
send -- "\r"
expect -exact "\[More\] "
send -- "\r"
expect -exact "\[More\] "
send -- "\r"
expect -exact "\[More\] "
send -- "\r"
expect -exact "\[More\] "
send -- "\r"
expect -exact "\[More\] "
send -- "\r"
expect -exact "\[More\] "
send -- "\r"
expect -exact "\[More\] "
send -- "\r"
expect -exact "\[More\] "
send -- "\r"
expect -exact "Do you accept the EULA license terms? \[yes/no\] "
send -- "y\r"

expect -exact "Would you like to add a udev entry to allow access to USB hardware?\r
  If a udev entry is not added, your cameras may only be accessible by running Spinnaker as sudo.\r
\[Y/n\] \$ "
send -- "n\r"
expect -exact "n\r
\r
Would you like to set USB-FS memory size to 1000 MB at startup (via /etc/rc.local)?\r
  By default, Linux systems only allocate 16 MB of USB-FS buffer memory for all USB devices.\r
  This may result in image acquisition issues from high-resolution cameras or multiple-camera set ups.\r
  NOTE: You can set this at any time by following the USB notes in the included README.\r
\[Y/n\] \$ "
send -- "y\r"

expect -exact "y\r
Launching USB-FS configuration script...\r
\r
Created /etc/rc.local and set USB-FS memory to 1000 MB.\r
\r
Would you like to have Spinnaker prebuilt examples available in your system path?\r
  This allows Spinnaker prebuilt examples to run from any paths on the system.\r
  NOTE: You can add the Spinnaker example paths at any time by following the \"RUNNING PREBUILT UTILITIES\"\r
        section in the included README.\r
\[Y/n\] \$ "
send -- "y\r"

expect -exact "y\r
Launching Spinnaker paths configuration script...\r
setup_spinnaker_paths.sh has been added to /etc/profile.d\r
The PATH environment variable will be updated every time a user logs in.\r
To run Spinnaker prebuilt examples in the current session, you can update the paths by running:\r
  source /etc/profile.d/setup_spinnaker_paths.sh\r
\r
Would you like to have the FLIR GenTL Producer added to GENICAM_GENTL64_PATH?\r
  This allows GenTL consumer applications to load the FLIR GenTL Producer.\r
  NOTE: You can add the FLIR producer to GENICAM_GENTL64_PATH at any time by following the GenTL Setup notes in the included README.\r
\[Y/n\] \$ "
send -- "y\r"

expect -exact "y\r
Launching GenTL path configuration script...\r
setup_flir_gentl_64.sh has been added to /etc/profile.d\r
The FLIR_GENTL64_CTI and GENICAM_GENTL64_PATH environment variables will be updated every time a user logs in.\r
To use the FLIR GenTL producer in the current session, you can update the FLIR_GENTL64_CTI and GENICAM_GENTL64_PATH environment variables by running:\r
  source /etc/profile.d/setup_flir_gentl_64.sh 64\r
\r
Installation complete.\r
\r
Would you like to make a difference by participating in the Spinnaker feedback program?\r
\[Y/n\] \$ "
send -- "n\r"

expect eof

'

sudo sh -c 'echo 1000 > /sys/module/usbcore/parameters/usbfs_memory_mb'
sudo sysctl -w net.core.rmem_max=10485760
sudo sysctl -w net.core.rmem_default=10485760


echo "Configuring udev rules..."
sudo $SCRIPT_DIR/udev_conf.sh

echo "Finished"

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

yes | sudo dpkg -i libgentl_*.deb
yes | sudo dpkg -i libspinnaker_*.deb
yes | sudo dpkg -i libspinnaker-dev_*.deb
yes | sudo dpkg -i libspinnaker-c_*.deb
yes | sudo dpkg -i libspinnaker-c-dev_*.deb
yes | sudo dpkg -i libspinvideo_*.deb
yes | sudo dpkg -i libspinvideo-dev_*.deb
yes | sudo dpkg -i libspinvideo-c_*.deb
yes | sudo dpkg -i libspinvideo-c-dev_*.deb
yes | sudo apt-get install -y ./spinview-qt_*.deb
yes | sudo dpkg -i spinview-qt-dev_*.deb
yes | sudo dpkg -i spinupdate_*.deb
yes | sudo dpkg -i spinupdate-dev_*.deb
yes | sudo dpkg -i spinnaker_*.deb
yes | sudo dpkg -i spinnaker-doc_*.deb


echo "Launching USB-FS configuration script..."
sudo sh configure_usbfs.sh

echo "Launching Spinnaker paths configuration script..."
sudo sh configure_spinnaker_paths.sh
    
if [ "$ARCH" = "amd64" ]; then
    BITS=64
elif [ "$ARCH" = "i386" ]; then
    BITS=32
fi

if [ -z "$BITS" ]; then
    echo "Could not automatically add the FLIR GenTL Producer to the GenTL environment variable."
    echo "To use the FLIR GenTL Producer, please follow the GenTL Setup notes in the included README."
else
    echo "Launching GenTL path configuration script..."
    sudo sh configure_gentl_paths.sh $BITS
fi
    
sudo sh -c 'echo 1000 > /sys/module/usbcore/parameters/usbfs_memory_mb'
sudo sysctl -w net.core.rmem_max=10485760
sudo sysctl -w net.core.rmem_default=10485760

echo "Configuring udev rules..."
sudo $SCRIPT_DIR/udev_conf.sh

echo "Finished"

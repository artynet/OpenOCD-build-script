#!/bin/bash

list="libusb-1.0.22 libusb-compat-0.1.5 eudev-3.2.7 hidapi OpenOCD libusb-compat-0.1"

for i in $list
do
    cd $i
    make distclean
    cd ..
done

# reset hidapi
git checkout hidapi

# reset libusb-compat-0.1.5 module
git checkout libusb-compat-0.1.5

# reset libusb-compat-0.1 trunk
cd libusb-compat-0.1/
git reset --hard HEAD
cd ..

# removing useless files
if [ "$1" == "all" ]
then
    git clean -f -d
fi

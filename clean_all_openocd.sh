#!/bin/bash

list="libusb-1.0.20 libusb-compat-0.1.5 eudev-3.1.5 hidapi OpenOCD-0.10.0 libusb-compat-0.1"

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
git clean -f -d

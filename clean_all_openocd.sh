#!/bin/bash

list="libusb-1.0.22 libusb-compat-0.1.7 eudev-3.2.7 hidapi OpenOCD libusb-compat-0.1"

for i in $list
do
    cd $i
    make distclean
    cd ..
done

# reset hidapi
git checkout hidapi

# reset libusb-compat-0.1.7 module
git checkout libusb-compat-0.1.7

# reset eudev-3.2.7 module
git checkout eudev-3.2.7

# reset libusb-compat-0.1 trunk
cd libusb-compat-0.1/
git reset --hard HEAD
cd ..

# removing autom4te cache where needed
rm -rf libusb*/autom4te.cache

# reset OpenOCD trunk
cd OpenOCD/
git reset --hard HEAD
cd ..

# removing useless files
if [ "$1" == "all" ]
then
    git clean -f -d
fi

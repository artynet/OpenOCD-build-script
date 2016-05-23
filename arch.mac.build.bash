#!/bin/bash

export CFLAGS="-arch x86_64 -arch i386 -mmacosx-version-min=10.5"
export CXXFLAGS="-arch x86_64 -arch i386 -mmacosx-version-min=10.5"
export LDFLAGS="-arch x86_64 -arch i386"
export HIDAPI_LDFLAGS="-lhidapi"

./clean.bash
rm -rf objdir

./libusb.build.bash
./libusb-compat-0.1.build.bash
./libftdi1.build.bash

# exit 0

USE_LOCAL_LIBUSB=yes ./hidapi.build.bash
USE_LOCAL_LIBUSB=yes ./openocd.build.bash

if [[ -f objdir/bin/openocd ]] ;
then
	strip --strip-all objdir/bin/openocd
	mv objdir/bin/openocd objdir/bin/openocd_bin
	cp launchers/openocd.mac objdir/bin/openocd
	chmod +x objdir/bin/openocd
fi

# ARCH=`gcc -v 2>&1 | awk '/Target/ { print $2 }'`
ARCH=universal

rm -rf OpenOCD-0.9.0-arduino
rm -f OpenOCD-0.9.0-arduino.org-$ARCH.tar.bz2
mv objdir OpenOCD-0.9.0-arduino
tar cfvj OpenOCD-0.9.0-arduino.org-$ARCH.tar.bz2 OpenOCD-0.9.0-arduino

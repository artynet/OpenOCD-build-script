#!/bin/bash -ex
# Copyright (c) 2016 Arduino LLC
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
ARCH=$(o64-clang -v 2>&1 | grep Target | awk {'print $2'} | sed 's/[.].*//g')

mkdir -p distrib/$ARCH/OpenOCD-osx-static
cd  distrib/$ARCH/OpenOCD-osx-static
PREFIX=`pwd`
cd -

#disable pkg-config
export PKG_CONFIG_PATH=`pwd`

cd libusb-1.0.20
export LIBUSB_DIR=`pwd`
CC=o64-clang CXX=o64-clang++ ./configure --enable-static --disable-shared --disable-udev \
    --host=$ARCH
make clean
make
cd ..

export LIBUSB1_CFLAGS="-I$LIBUSB_DIR/libusb/"
export LIBUSB1_LIBS="-L$LIBUSB_DIR/libusb/.libs/ -lusb-1.0 -lpthread"

export LIBUSB_1_0_CFLAGS="-I$LIBUSB_DIR/libusb/"
export LIBUSB_1_0_LIBS="-L$LIBUSB_DIR/libusb/.libs/ -lusb-1.0 -lpthread"

cd libusb-compat-0.1.7
export LIBUSB0_DIR=`pwd`
autoreconf
CC=o64-clang CXX=o64-clang++ ./configure --enable-static --disable-shared --disable-udev \
    --host=$ARCH
make clean
make
cd ..

export libusb_CFLAGS="-I$LIBUSB_DIR/libusb/"
export libusb_LIBS="-L$LIBUSB_DIR/libusb/.libs/ -lusb-1.0 -lpthread"

cd hidapi
./bootstrap
export HIDAPI_DIR=`pwd`
CC=o64-clang CXX=o64-clang++ ./configure --enable-static --disable-shared --disable-udev \
    --host=$ARCH
make clean
make -j4
cd ..

cd OpenOCD
./bootstrap
export LIBUSB0_CFLAGS="-I$LIBUSB0_DIR/libusb/"
export LIBUSB0_LIBS="-L$LIBUSB0_DIR/libusb/.libs/ -lusb"
export LIBUSB1_CFLAGS="-I$LIBUSB_DIR/libusb/"
export LIBUSB1_LIBS="-L$LIBUSB_DIR/libusb/.libs/ -lusb-1.0"
export HIDAPI_CFLAGS="-I$HIDAPI_DIR/hidapi/"

export HIDAPI_LIBS="-L$HIDAPI_DIR/mac/.libs/ -L$HIDAPI_DIR/libusb/.libs/ -lhidapi"

export CFLAGS="-DHAVE_LIBUSB_ERROR_NAME"
PKG_CONFIG_PATH=`pwd` CC=o64-clang CXX=o64-clang++ ./configure --disable-werror --prefix=$PREFIX \
    --host=$ARCH
make clean
CFLAGS=-static make
make install

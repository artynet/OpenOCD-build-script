#!/bin/bash -ex

if [[ ! -f libftdi1-1.2.tar.bz2 ]] ;
then
	wget http://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.2.tar.bz2
fi

tar xfv libftdi1-1.2.tar.bz2

# patching libfdti1

cd libftdi1-1.2
patch -p0 < ../patches/libftdi1-1.2-cmake-FindUSB1.patch
cd ..

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p libftdi1-build
cd libftdi1-build

PKG_CONFIG_LIBDIR=\
"$PREFIX/lib/pkgconfig":\
"$PREFIX/lib64/pkgconfig" \
cmake \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DBUILD_TESTS:BOOL=off \
  -DFTDIPP:BOOL=off \
  -DPYTHON_BINDINGS:BOOL=off \
  -DEXAMPLES:BOOL=off \
  -DDOCUMENTATION:BOOL=off \
  -DFTDI_EEPROM:BOOL=off \
  -DLIBUSB_INCLUDE_DIR=${PREFIX}/include/libusb-1.0 \
  ../libftdi1-1.2

make && make install

#!/bin/bash -ex

#if [[ -d OpenOCD ]] ;
#then
#	cd OpenOCD
#	git clean -fd
#	git reset --hard
#	cd -
#fi
#
#if [[ -d hidapi ]] ;
#then
#	cd hidapi
#	git clean -fd
#	git reset --hard
#	cd -
#fi

rm -rf libusb-1.0.19 libusb-compat-0.1.4 *-build hidapi objdir OpenOCD*

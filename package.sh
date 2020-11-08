#!/bin/bash -ex
# Copyright (c) 2014-2016 Arduino LLC
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

OUTPUT_VERSION=0.10.0-arduino13-static

export OS=`uname -o || uname`

#add osxcross, mingw and arm-linux-gnueabihf paths to PATH

# windows
./clean_all_openocd.sh
./compile_win_openocd.sh

# linux 64
./clean_all_openocd.sh
./compile_unix_openocd.sh

# linux 32
./clean_all_openocd.sh
./compile_unix_openocd.sh 32

# arm
./clean_all_openocd.sh
./compile_arm_openocd.sh

# osx
./clean_all_openocd.sh
./compile_osx_openocd.sh

# final clean
./clean_all_openocd.sh

package_index=`cat package_index.template | sed s/%%VERSION%%/${OUTPUT_VERSION}/`

cd distrib

rm -f *.bz2

folders=`ls`
t_os_arr=($folders)

for t_os in "${t_os_arr[@]}"
do
	FILENAME=openocd-${OUTPUT_VERSION}-${t_os}.tar.bz2
	tar -cjvf ${FILENAME} ${t_os}/
	SIZE=`stat --printf="%s" ${FILENAME}`
	SHASUM=`sha256sum ${FILENAME} | cut -f1 -d" "`
	T_OS=`echo ${t_os} | awk '{print toupper($0)}'`
	echo $T_OS
	package_index=`echo $package_index |
		sed "s/%%FILENAME_${T_OS}%%/${FILENAME}/" |
		sed "s/%%FILENAME_${T_OS}%%/${FILENAME}/" |
		sed "s/%%SIZE_${T_OS}%%/${SIZE}/" |
		sed "s/%%SHA_${T_OS}%%/${SHASUM}/"`
done
cd -

set +x

echo ================== CUT ME HERE =====================

echo ${package_index} | python3 -m json.tool

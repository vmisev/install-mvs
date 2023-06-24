#!/bin/sh
clear; echo "\
 
 This scripts removes older version of SDL Hercules 390 hyperion and
 downloads Hercules-Helper which builds latest SDL Hercules 390 hyperion
 from https://github.com/SDL-Hercules-390/hyperion
 using Hercules-Helper https://github.com/wrljet/hercules-helper
 by Bill Lewis bill@wrljet.com
 
 rebuild-herc.sh by Vladimir Mišev (twitter.com/vmisev)
 "
printf "%s " " Please press Enter to continue or ^C to stop"
read ans
#
BINDIR=$HOME/bin
TK4DIR=$BINDIR/tk4sys
INSTDIR=$TK4DIR/hercules/freebsd
#
HELPER=https://github.com/wrljet/hercules-helper.git
#
pkg info -e sudo
if [ $? -eq 0 ]; then
	SU=sudo; else
		pkg info -e doas
		if [ $? -eq 1 ]; then 
			echo -e "\n Please install sudo or doas"; exit 1
		fi
	SU=doas
fi
#
echo -e "\n Installing packages needed for SDL Hercules 390 hyperion build \n"
$SU pkg install -qy	autoconf automake bash bzip2 cmake flex gawk \
			git gmake libltdl libtool m4 rexx-regina wget
# 
echo -e "\n Removing older version of SDL Hercules 390 hyperion \n"
cd $BINDIR ; rm -rf -- $INSTDIR/*
[ ! -d "$INSTDIR" ] && mkdir -p "$INSTDIR"
#
echo -e "\n Fetching and building Hercules-Helper \n"
[ ! -d "hercules-helper" ] && \
	git clone $HELPER
cd hercules-helper
for i in *.conf
	do sed -i '' "s#opt_install_dir=..*#opt_install_dir=$INSTDIR#g" $i
done
./hercules-buildall.sh --flavor=sdl-hyperion --no-bashrc
rm -rf -- $BINDIR/hercules-helper
#
echo -e "\n SDL Hercules 390 hyperion is installed and ready to run \n"
#

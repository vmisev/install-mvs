#!/bin/sh
clear; echo "\
 
 This scripts downloads, builds and installs SDL Hercules 390 hyperion from
 https://github.com/SDL-Hercules-390/hyperion
 using hercules-helper https://github.com/wrljet/hercules-helper
 by Bill Lewis bill@wrljet.com

 and

 Jürgen Winkelsmann's MVS Turnkey 4 MVS 3.8j (TK4-)
 with updates by Rob Prins (TK4ROB) from
 http://www.prince-webdesign.nl/index.php/software/update-on-mvs-turnkey-4

 Hercules and TK4- will be installed in the ~/bin/tk4sys
 run-mvs, run-herc and run-3270 scripts will be installed in the ~/bin
 Unneeded files (linux, darwin, windows) are not extracted from tk4sys.zip

 Script assumes that X.Org is installed, that's why x3270
 If running in vt only please s/x3270/c3270/g

 install-msv.sh by Vladimir Mišev (twitter.com/vmisev)
 "
printf "%s " " Please press Enter to continue or ^C to stop"
read ans
#
BINDIR=$HOME/bin
TK4DIR=$BINDIR/tk4sys
INSTDIR=$TK4DIR/hercules/freebsd
#
HELPER=https://github.com/wrljet/hercules-helper.git
TK4ROB=http://www.prince-webdesign.nl/images/downloads/tk4sys.zip
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
pkg info -e x3270
if [ $? -eq 1 ]; then 
	$SU pkg install -qy x3270
	xset fp+ /usr/local/share/fonts/x3270/
	xset fp rehash
	$SU sh -c 'echo -e "Section \"Files\" \
\\tFontPath \"/usr/local/share/fonts/x3270/\" \
EndSection" >> /usr/local/etc/X11/xorg.conf.d/90-fonts.conf'
fi
#
[ ! -d "$BINDIR" ] && mkdir -p "$BINDIR"
cd $BINDIR
[ ! -d "$TK4DIR" ] && \
echo -e "\n fetching and extracting TK4- \n"; \
fetch -qo- $TK4ROB | \
	tar	--exclude='./mvs' \
		--exclude='./mvs.*' \
		--exclude='./mvs_*' \
		--exclude='./activate*' \
		--exclude='./deactivate*' \
		--exclude='./start*' \
		--exclude='./hercules_*' \
		--exclude='./hercules/darwin' \
		--exclude='./hercules/external*' \
		--exclude='./hercules/linux' \
		--exclude='./hercules/windows' \
		--exclude='./hercules/version*' \
		-x
[ ! -d "$INSTDIR" ] && mkdir -p "$INSTDIR"
#
echo -e "\n fetching and building hercules-helper \n"
[ ! -d "hercules-helper" ] && \
	git clone $HELPER
cd hercules-helper
for i in *.conf
	do sed -i '' "s#opt_install_dir=..*#opt_install_dir=$INSTDIR#g" $i 
done
./hercules-buildall.sh --flavor=sdl-hyperion --no-bashrc
rm -rf $BINDIR/hercules-helper
#
echo -e "\n making run-* scripts \n"
cat <<'EOF' >$BINDIR/run-mvs
#!/usr/bin/env bash
BINDIR=$HOME/bin
TK4DIR=$BINDIR/tk4sys
INSTDIR=$TK4DIR/hercules/freebsd
cd $TK4DIR
set +u
newpath=$INSTDIR/bin
if [ -d "$newpath" ] && [[ ":$PATH:" != *":$newpath:"* ]]; then
	export PATH=$newpath${PATH:+":$PATH"}
fi
#
newpath=$INSTDIR/lib
if [ -d "$newpath" ] && [[ ":$LD_LIBRARY_PATH:" != *":$newpath:"* ]]; then
	export LD_LIBRARY_PATH=$newpath${LD_LIBRARY_PATH:+":$LD_LIBRARY_PATH"}
fi
#
if [ -f local_conf/tk4-.parm ]; then . local_conf/tk4-.parm; fi
export HERCULES_RC=scripts/ipl.rc
hercules -f conf/tk4-.cnf >log/3033.log;
EOF
#
cat <<'EOF' >$BINDIR/run-herc
#!/usr/bin/env bash
BINDIR=$HOME/bin
TK4DIR=$BINDIR/tk4sys
INSTDIR=$TK4DIR/hercules/freebsd
cd $TK4DIR
set +u
newpath=$INSTDIR/bin
if [ -d "$newpath" ] && [[ ":$PATH:" != *":$newpath:"* ]]; then
	export PATH=$newpath${PATH:+":$PATH"}
fi
#
newpath=$INSTDIR/lib
if [ -d "$newpath" ] && [[ ":$LD_LIBRARY_PATH:" != *":$newpath:"* ]]; then
	export LD_LIBRARY_PATH=$newpath${LD_LIBRARY_PATH:+":$LD_LIBRARY_PATH"}
fi
#
if [ -f local_conf/tk4-.parm ]; then . local_conf/tk4-.parm; fi
export HERCULES_RC=scripts/tk4-.rc
export TK4CONS=extcons
hercules -f conf/tk4-.cnf > log/3033.log
EOF
#
cat <<'EOF' >$BINDIR/run-3270
#!/bin/sh
x3270 -port 3270 localhost
EOF
#
chmod 750 $BINDIR/run-mvs $BINDIR/run-herc $BINDIR/run-3270
#
echo -e "\nSDL-Hercules-390 / hyperion is installed and ready to run \n\
TK4- MVS 3.8j Tur(n)key System. Please run ~/bin/run-mvs \n\n\
To connect to your SDL-Hercules-390 please run ~/bin/run-3270 \n"
#
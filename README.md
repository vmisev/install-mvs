# install-mvs
shell script for installing SDL Hercules 390 hyperion and TK4- MVS on FreeBSD

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

# install-mvs   

**shell script for installing**  
**SDL Hercules 390 hyperion and TK4- MVS on [FreeBSD](https://www.freebsd.org/)**   

This scripts downloads, builds and installs [SDL Hercules 390 hyperion](https://github.com/SDL-Hercules-390/hyperion) using  
[Hercules-Helper](https://github.com/wrljet/hercules-helper) by [Bill Lewis](https://github.com/wrljet) and Jürgen Winkelsmann's [MVS 3.8j Tur(n)key 4- System](https://wotho.ethz.ch/tk4-/) (TK4-)  
with updates by Rob Prins [(TK4ROB)](http://www.prince-webdesign.nl/index.php/software/update-on-mvs-turnkey-4)   
  

Hercules and TK4- will be installed in the `~/bin/tk4sys`  
run-mvs, run-herc and run-3270 scripts will be installed in the `~/bin`  
Unneeded files (*linux, darwin, windows*) are not extracted from [tk4sys.zip](http://www.prince-webdesign.nl/images/downloads/tk4sys.zip)  

Script assumes that X.Org is installed, that's why x3270  
If running in [vt(4)](https://man.freebsd.org/cgi/man.cgi?query=vt&sektion=4) only please `s/x3270/c3270/g`  

Since [SDL Hercules 390 hyperion](https://github.com/SDL-Hercules-390/hyperion) is updated much more often than TK4-   
there is also [rebuild-herc.sh](https://github.com/vmisev/install-mvs/blob/main/rebuild-herc.sh) script which will only rebuild Hercules and   
leave all TK4- directories and configs unchanged.


install-msv.sh by [Vladimir Mišev](https://twitter.com/vmisev)  

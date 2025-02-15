# bmde-linux
Partial port of the `BMDE` (bare metal development environment) to Linux (and subsequently to Docker) from the URV 
subject 
Computer Fundamentals, 
Computers and Operating System Structure, to achieve compilation of the C and assembly projects of the subjects into
runnable .nds roms.

# Components
## Libraries provided by devkitPro 
From the original `BMDE` environment. Originally obtained from devkitPro updater v1.6.0 for Windows. 
* libgba Version=0.5.0
* libgbafat Version=1.1.0
* maxmodgba Version=1.0.10
* libnds Version=1.6.2
* libndsfat Version=1.1.0
* defaultarm7 Version=0.7.1
* filesystem Version=0.9.13-1
* dswifi Version=0.4.0
* libmirko Version=0.9.7
* maxmodds Version=1.0.10
* libctru Version=1.2.1
* citro3d Version=1.2.0

## devkitARM
Version 46, downloaded from [here](https://wii.leseratte10.de/devkitPro/devkitARM/r46%20%282017%29/).

# Removed components from original BMDE
* (Not needed since we already have a working Linux environment) msys Version=1.0.17-1 
* (Not needed for compilation, can be included afterwards) 3dsexamples Version=20170226,ndsexamples Version=20170124, gbaexamples Version=20170228, gp32examples Version=20051021
* (Not needed, we do not want to debug the software, only compile it) insight Version=7.3.50.20110803

# Changes done to the original files



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

# Install it directly into your linux system for manual usage
This is not the preferred way to run this software, but is possible to do it, though I am (currently) not providing 
scripts to automatically do so. I will provide some instructions if someone wants to try it out, since surprisingly with 
the right binaries the environment works with minor changes.

1. Download devkitARM from [here](https://wii.leseratte10.de/devkitPro/devkitARM/r46%20%282017%29/) and decompress it.
2. Decompress `libnds.tar.bz2` from the `data` folder of this repository.
3. Mount the following tree from any file system point of your like, but this will condition the subsequent steps:
```
/ANY_FOLDER/
/ANY_FOLDER/devkitPro/
/ANY_FOLDER/devkitPro/devkitARM
/ANY_FOLDER/devkitPro/libnds
```
Also, create the environment variables `DEVKITPRO=/ANY_FOLDER/devkitPro`, `DEVKITARM=$DEVKITPRO/devkitARM` and 
`DESMUME="/"` 
(for compatibility purposes). Also add the path `$DEVKITARM/bin` into the beginning of the `PATH` environment variable. 
You
can do it with:
```shell
PATH=$DEVKITARM/bin:$PATH
```
4. Move the decompressed files of devkitARM into `/ANY_FOLDER/devkitPro/devkitARM` and the decompressed files of 
`libnds.tar.bz2` into 
`/ANY_FOLDER/devkitPro/libnds`
5. Install `make` using your package manager and use `make` to try to compile your software. 
6. If the `#include <nds.h>` directive does not found the corresponding file, add the `include` folder from the `libnds`
into the `base_rules` of devkitPro: `$(CC) -I/ANY_FOLDER/devkitPro/libnds/include/ -c myfile.c`
7. Afterwards, if it still does not work, you will need to add the binaries of the libnds library manually into
`ds_rules` for linking `.o` to `.elf`. The error after step 6 looked like this:
```
/bmde/devkitPro/devkitARM/bin/../lib/gcc/arm-none-eabi/6.3.0/../../../../arm-none-eabi/bin/ld: cannot find -lnds9
```
You need to add `-L/path/to/libnds` to the corresponding `Makefile` rule (the one that is failing).
8. Finally, the `ndstool` will be complaining about not finding the `default.elf`, which to solve I move to the 
location were `ndstool` was expecting the file. I could not change the "rule" files like I did in previous steps because 
I could not find a way to configure `ndstool` to use the `default.elf` file from another location.
9. Finally, you can open a terminal in the project that you want to compile and execute `make` to compile the project. 
The projects can be located in any path of your liking. 


# Use environment for manual usage


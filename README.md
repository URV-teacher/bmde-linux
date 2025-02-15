Partial port of the BMDE (bare metal development environment) to Linux (and subsequently to Docker) from the URV 
subject 
Computer Fundamentals, 
Computers and Operating System Structure, to achieve compilation of the C and assembly projects of the subjects into
runnable `.nds` roms.

The original BMDE is an environment to compile, run, debug and develop NDS (Nintendo DS) software projects written in C 
and Assembly for Windows systems in a repeatable and didactic manner.

# Components
## Libraries provided by devkitPro 
From the original `BMDE` environment. Originally obtained from devkitPro updater v1.6.0 for Windows.

| Library     | Version  |
|-------------|----------|
| libgba      | 0.5.0    |
| libgbafat   | 1.1.0    |
| maxmodgba   | 1.0.10   |
| libnds      | 1.6.2    |
| libndsfat   | 1.1.0    |
| defaultarm7 | 0.7.1    |
| filesystem  | 0.9.13-1 |
| dswifi      | 0.4.0    |
| libmirko    | 0.9.7    |
| maxmodds    | 1.0.10   |
| libctru     | 1.2.1    |
| citro3d     | 1.2.0    |


## devkitARM
Version 46, downloaded from [here](https://wii.leseratte10.de/devkitPro/devkitARM/r46%20%282017%29/).

# Removed components from original BMDE
| Name         | Version         | Notes                                                               |
|--------------|-----------------|---------------------------------------------------------------------|
| msys         | 1.0.17-1        | (Not needed since we already have a working Linux environment)      |
| 3dsexamples  | 20170226        | (Not needed for compilation, can be included afterwards)            |
| ndsexamples  | 20170124        | (Not needed for compilation, can be included afterwards)            |
| gbaexamples  | 20170228        | (Not needed for compilation, can be included afterwards)            |
| gp32examples | 20051021        | (Not needed for compilation, can be included afterwards)            |
| insight      | 7.3.50.20110803 | (Not needed, we do not want to debug the software, only compile it) |


# Usage

## Use environment for automatic compilation through `docker compose`
Clone the repository and enter inside it. Instead, you can also create the `input` and `output` folder for mount points
for `docker compose` and download the `compose.yml` file into an arbitrary folder:
```shell
git clone https://github.com/URV-teacher/bmde-linux
cd bmde-linux
```

Add all the projects that you want to compile inside the `input/` directory. For example, you could do...
```shell
cd input
git clone https://github.com/URV-teacher/hello-world-nds
```

... to clone the `hello-world-nds` project. 

Afterwards, `cd` back into the `bmde-linux` project and run `docker compose up`:
```shell
cd bmde-linux
docker compose up 
```

After the execution you will see the resulting `.nds` files from the projects in the `input` folder inside the `output` 
folder. You will also see the resulting binaries and the build artifacts inside each corresponding project, inside 
the `input` folder, if you want to check out anything. 


## Customizing / extending the BMDE environment for Linux
Inside your project folder, create a `Dockerfile` with a `FROM` directive that points to the Docker container of BMDE:
```dockerfile
# Extend bmde container
FROM aleixmt/bmde-linux:latest
# Copy directory of the project into /workspace dir for automatic compilation 
COPY . /workspace/
# Add any more instruction for the building of your image
```

Also copy the `compose.yml` file from this repo to yours as starters. Then, you will be able to compile your software 
from scratch with `docker compose up --build --no-cache`, you will find the resulting binaries in the `output` folder.


## Use environment for manual usage inside container through `docker run`
With docker installed, use:
```shell
docker run -it aleixmt/bmde-linux:latest
```

Since we are running the image directly without loading any data inside it, we will enter inside the container in
interactive mode.

To put data inside it, we will probably need to install some commands to connect to the Internet. For example, to
install git:
```shell
sudo apt-get install -y git
```

Afterwards, we can clone a repo, for example, we could do:
```shell
git clone https://github.com/URV-teacher/hello-world-nds
```

And then `cd` inside the repository and compile the software with `make`.

To move the results of the compilation (usually `.nds` files),
you can communicate a folder from inside the container with a folder of your host by adding parameters into the `docker
run` command to mount a volume. I will not explain it because it is better to use the `compose.yml` through `docker
compose`, which automatically mounts volumes.


## Install it directly into your Linux system for manual usage
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

Installation steps may change, specially the ones regarding the specification of paths of libraries in the base rules of
the devkitARM toolchain. Luckily, when building the container, we do not needed to specify the path of any libraries.
They were found automatically. 

## Run `.nds` files into DeSmuME
I recommend using `flatpak` to run DeSmuME:
```shell
flatpak install flathub org.desmume.DeSmuME
flatpak run org.desmume.DeSmuME
```

This will run DeSmuME in a containerized manner, using another container technology for graphical applications called 
`flatpak`.

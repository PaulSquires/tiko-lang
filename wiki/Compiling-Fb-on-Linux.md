[Home](Home) › [Compiler Internals](Category-Compiler-Internals) › **Compiling FB on Linux**

# Compiling FB on Linux

Building FB on Linux is fairly easy because usually the GNU/Linux distributions provide all the needed development packages and they can be installed easily, at least for native builds. Since 64bit support was added to FB, a native build should always be possible, no matter whether you have a 32bit x86 or 64bit x86_64 system. Cross-compiling the 32bit x86 version of FB on a 64bit x86_64 system (or vice-versa) and building for other architectures such as ARM is also possible.

 Generally, compiling FB-linux requires the following packages:

- an existing, working FreeBASIC setup for bootstrapping the new compiler
- gcc
- make
- ncurses development headers & libraries (actually only its libtinfo part)
- libtinfo development headers & libraries (if not automatically installed as part of ncurses)
- gpm development headers & libraries (general purpose mouse)
- X11 development headers & libraries (including X11, Xext, Xpm, Xrandr, Xrender)
- OpenGL development headers & libraries (typically from the Mesa project)
- libffi development headers & libraries

***Native build***

 **Getting the FB source code**

 To compile a new version of FB, you first need to [get the FB source code](Getting-the-Source-Code). The following assumes that you have a directory called `fbc`, containing the latest FB source code.

 **Getting an existing FB-linux setup for bootstrapping**

 We will need a working FB-linux installation to bootstrap the new FB compiler. If you do not have a native version of FB installed yet, download the latest FreeBASIC-X.XX.X-linux release for your system (32bit x86, 64bit x86_64, ARM, etc.) from [FB's download site](http://sourceforge.net/projects/fbc/files/Binaries%20-%20Linux/), then extract and install it:

```freebasic
$ tar xf FreeBASIC-X.XX.X-linux.tar.gz
$ cd FreeBASIC-X.XX.X-linux
$ sudo ./install.sh -i
```

 It is possible that you can get working FB setups from other sources besides the fbc project. For example, some distros may provide `freebasic` packages out-of-the-box.

 **Installing development packages**

 The following lists show the packages you have to install for some common GNU/Linux distributions. The exact package names can be different depending on which distro (or which version of it) you use.

 Debian-based systems (including Ubuntu, Mint etc.):

- `gcc`
- `make`
- `libncurses5-dev`
- `libtinfo5` (if not already installed as dependency of ncurses)
- `libgpm-dev`
- `libx11-dev`
- `libxext-dev`
- `libxpm-dev`
- `libxrandr-dev`
- `libxrender-dev`
- `libgl1-mesa-dev`
- `libffi-dev`

OpenSUSE:

- `gcc`
- `make`
- `ncurses-devel`
- `libncurses5`
- `gpm-devel`
- `libX11-devel`
- `libXext-devel`
- `libXpm-devel`
- `libXrandr-devel`
- `libXrender-devel`
- `libtinfo5` (if not already installed as dependency of ncurses)
- `Mesa-libGL-devel`
- `libffi-devel`

Fedora:

- `gcc`
- `make`
- `ncurses-devel`
- `ncurses-compat-libs.x86_64` (may be needed for libtinfo.so.5 if it is not already installed as dependency of ncurses)
- `gpm-devel`
- `libX11-devel`
- `libXext-devel`
- `libXpm-devel`
- `libXrandr-devel`
- `libXrender-devel`
- `mesa-libGL-devel`
- `libffi-devel`

**Compiling FB**

 Compiling FB natively is as simple as running "make" in the fbc source code directory. This will build a native FB setup matching the system architecture, assuming that the existing fbc installed on the system produces native programs.

```freebasic
$ cd fbc
$ make
```

 This should have produced the `bin/fbc` compiler and the libraries in `lib\freebasic\linux-[architecture]\`.

 Afterwards, you can install the new fbc build into `/usr/local` by running "make install", and overwrite the old FB installation:

```freebasic
$ sudo make install
```

 ***Compiling 32bit FB on a 64bit system with existing 32bit FB***

 Besides native builds, you can also make non-native builds, such as compiling the 32bit version of FB on a 64bit system, using an existing 32bit FB build to bootstrap. This was very common before 64bit support was added to FB. It requires a slightly different procedure than a native build.

- Get the FB source code.
- Install a 32bit version of FB for bootstrapping (instead of a native 64bit version).
- Install 32bit development packages (not just the native 64bit ones).

64bit Debian/Ubuntu example:

64bit OpenSUSE example:

- Add the following `config.mk` file to the fbc source tree (next to the FB makefile):

```freebasic
CC = gcc -m32
TARGET_ARCH = x86
```

This tells the FB makefile to build for 32bit instead of the 64bit default.

 Setting CC to `gcc -m32` instead of `gcc` causes all C code to be compiled for 32bit rather than the default 64bit.

 Assuming that the existing installed fbc is a 32bit one, it will already default to compiling to 32bit, so setting FBC to `fbc -arch 32` instead of `fbc` is not needed (and older 32bit-only fbc versions did not even have the `-arch 32` option anyways).

 Setting the TARGET_ARCH to x86 is necessary to override the FB makefile's `uname -m` check (because that returns x86_64 on 64bit). This allows the FB makefile to select the proper x86 rtlib/gfxlib2 modules and to use the correct directory layout for x86.

- Run "make" and let it compile FB:

```freebasic
$ cd ~/fbc
$ make
```

- Optionally, install the newly built 32bit FB setup into `/usr/local`:

```freebasic
$ sudo make install
```

---

**Category:** [Compiler Internals](Category-Compiler-Internals)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Installing**

# Installing

Installing FreeBASIC, any additionally needed packages, and perhaps a text editor or IDE.

 *Note: If the user specifies directory names during the installation of the different components, it is recommended in the chosen names to use only alphanumeric ASCII characters without accent and preferably not any space, otherwise some paths might not work as expected.*

 ***Windows 32bit***

- Download the latest [FreeBASIC-x.xx.x-win32.zip](https://sourceforge.net/projects/fbc/files/Binaries%20-%20Windows/) package, or the latest [FreeBASIC-x.xx.x-win32.exe](https://sourceforge.net/projects/fbc/files/Binaries%20-%20Windows/) installer (not recommended for Windows 7 and later versions).
  Depending on the chosen method:

  - Zip package: Extract it where you like, for example at `...\FreeBASIC` (no further installation required to use fbc).
  Installer (not recommended for Windows 7 and later versions): Run it and click through it. The installer will install FreeBASIC at `C:\%ProgramFiles%\FreeBASIC`, or if you chose a different installation directory, in your chosen directory. Start Menu shortcuts to the website will be installed as well.

  Unless you already have a source code editor or IDE, you should install one too, as FreeBASIC itself does not include one. An IDE can be used to write and save .bas files and to launch the FreeBASIC Compiler to compile them. The following IDEs are known to explicitly support FreeBASIC:

  - [FBIDE](http://fbide.freebasic.net/)
  - [FBEdit](http://radasm.cherrytree.at/fbedit/)
  - [WinFBE Editor and Visual Designer](https://www.freebasic.net/forum/viewtopic.php?f=8&t=25215)

To uninstall FreeBASIC:

***Windows 64bit***

- Download the latest [FreeBASIC-x.xx.x-win64.zip](https://sourceforge.net/projects/fbc/files/Binaries%20-%20Windows/) package.
  Extract it where you like, for example at `...\FreeBASIC` (no further installation required to use fbc).  
  You may want to install a source code editor or IDE; also see the **Windows 32bit** section.

To uninstall FreeBASIC, simply deleted the directory where you extracted it.

***Linux***

- Download the latest [FreeBASIC-x.xx.x-linux-x86.tar.gz (32bit) or FreeBASIC-x.xx.x-linux-x86_64.tar.gz (64bit)](https://sourceforge.net/projects/fbc/files/Binaries%20-%20Linux/) package
  Extract the archive, for example by doing right-click -> Extract Here, or manually in a terminal:

```freebasic
$ cd Downloads
$ tar xzf FreeBASIC-x.xx.x-linux-x86.tar.gz
```

- The FreeBASIC compiler can be used from where it was extracted. Usually it is installed into the `/usr/local` system directory though, so that the `fbc` program is available through-out the whole system. To do that, run the included installation script:

```freebasic
$ cd FreeBASIC-x.xx.x-linux-x86
$ sudo ./install.sh -i
```

 The `install.sh` script can also be given a path as in `./install.sh -i /usr` if you prefer to install into a directory other than the default `/usr/local`. This default is a good choice though, as it avoids mixing with the content of `/usr` which is usually managed by the distribution's packaging tool.

- FreeBASIC requires several additional packages to be installed before it can be used to compile executables. In general, these are:

The actual package names to install vary depending on the GNU/Linux distribution.

 For native development (32bit FB on 32bit system, or 64bit FB on 64bit system):

For 32bit development on a 64bit system:

- Unless you already have a text editor or IDE, you should install one too, as FreeBASIC itself does not include one. An IDE can be used to write and save .bas files and to launch the FreeBASIC Compiler to compile them. The following IDEs are known to explicitly support FreeBASIC:

  - [Geany](http://www.geany.org/)

To uninstall FreeBASIC from `/usr/local`, you can run the install.sh script again, but with the -u option: `sudo ./install.sh -u`

***DOS***

- Download the latest [FreeBASIC-x.xx.x-dos.zip](https://sourceforge.net/projects/fbc/files/Binaries%20-%20DOS/) archive
  Find a place for FreeBASIC with at least 13 MiB free space.  
  Unpack the ZIP archive, making sure that the directory structure as used inside the archive is preserved ("PKUNZIP -d" for example).  
  The top-level directory is named FreeBASIC-x.xx.x-dos (will be truncated to "FREEBASI" in DOS without full LFN support), so you might want to rename it then to a convenient DOS-compliant name not longer than 8 characters and containing no white-spaces, like "FB".  
  All the important files used by the compiler (includes, libs) inside the archive do have DOS-compliant names, therefore DOSLFN is not required to use FreeBASIC, however, some examples and texts do have longer names and will be truncated when extracted without full LFN support.

(Note: you can install the DOS version "over" the Windows one or vice-versa, or "merge" those installations later, but rename the FBC.EXE file of the previous installation to FBCW.EXE , FBCD.EXE or such, or it will be overwritten by the new one. Other platform specific files are placed in subdirectories making sure that they won't conflict.)

***Compiling under Ubuntu 10.04 LTS, 64-bit:***
 This comment applies to FB 1.01.0, and may apply to other builds also.  
 Install all of the Libraries listed above; some of the entries ending in ":i386" may throw "not found" errors.  
 To verify that you're using a 64-bit build, use: "uname -a" or "uname -m" (it'll show x86_64 for 64-bit, i386 for 32-bit).  
 Then, when running FBC, an error may appear: "error while loading shared libraries: libtinfo.so.5: cannot open shared object file: No such file or directory".

 "libtinfo.so.5" is available as a separate library in Ubuntu 11.10+, but it is built into "ncurses.so.5" in 10.04 LTS. So, we need to re-direct the libtinfo references into the ncurses.so.5 libraries:

- Issue: find / -name 'libtinfo.so.5' - just to verify that there are no confusing references to these libraries anywhere. Any references should be checked, and probably deleted?
  Change to the folder containing the FBC executable (perhaps "/usr/local/bin/").  
  Issue: ldd fbc - it will list the various library folder(s) being searched (probably "/lib32" in most cases).  
  Issue: sudo ln -s /lib32/libncurses.so.5 /lib32/libtinfo.so.5 (assuming "/lib32" was emitted in the previous step).  
  Issue: sudo ln -s /lib32/libtinfo.so.5 /lib32/libtinfo.so (assuming "/lib32"...)  
  Retry!  
  \[Unrelated point: if "private" Libraries are needed for compiles, they were expected to be in /usr/local/lib/freebasic/. Now, they may have to be in /usr/local/lib/freebasic/linux-x86/\].  
  \[Mike Kennedy, Jan, 2015. (This note was not acceptable as a standard "comment" - I don't know why?)\].

See also

- [Invoking the Compiler](Running)
- [Compiler Command Line Options](Fbc-Command-Line)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

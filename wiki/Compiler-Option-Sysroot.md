[Home](Home) › **Compiler Option: -sysroot**

# Compiler Option: -sysroot

Add a path to search for libraries

Syntax

`-sysroot < sysroot path >`

Parameters

`sysroot path`

The directory path of the sysroot for the toolchain used.

Description

The `-sysroot` compiler option passes this directory location to the linker to indicate where the linker should look for default object modules and libraries.

 This passes on some responsibility of finding needed resources to the toolchain. Typically only needed when cross compiling where resources are expected to be in a single directory structure and expected to be found at known locations relative to the `sysroot`.

 To explicitly locate libraries use [`#libpath`](Libpath) or [Compiler Option: -p](Compiler-Option-P).

Version


See also

- [`#libpath`](Libpath)
- [Using the Command Line](Quick-Start#compile-a-program)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

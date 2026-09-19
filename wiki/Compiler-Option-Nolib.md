[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -nolib**

# Compiler Option: -nolib

Do not include specific library(s).

Syntax

`-nolib < libname1 [, libname2 [, ... ] ] >`

Parameters

`libname1`, `libname2`, ...

Name (without name's extension) of each library to exclude.

`fbrt0.o`  
 `fbrt0pic.o`

Exclude the fb runtime library start-up code module

Description

The `-nolib` compiler option allows excluding specific libraries when linking, no matter where it came from (default lib, #inclib, -l, objinfo...).  
 (more fine-grained control than [`-nodeflibs`](Compiler-Option-Nodeflibs), and not only for default libraries)

 This allows selectively blacklisting libraries and can be used to:

**-** remove unused dependencies when linking against shared libraries (when linking against static libraries via -l, the linker automatically skips unused libs, but not for shared libraries),
 **-** override unwanted #inclibs (although arguably this is not the ideal solution for that, but just a last resort),
 **-** disable only some default libs, instead of all as done by [`-nodeflibs`](Compiler-Option-Nodeflibs):

For example, this could be used to specifically omit `libtinfo`.  
 Using [`-nodeflibs`](Compiler-Option-Nodeflibs) would omit a lot more (including `fbrt0.o`) which would have to be re-added manually again.

**-** remove only the fb runtime library start-up code module allowing replacement with a custom start-up module without affect any other libraries named in the link

Version

- Since fbc 1.20.0: `-nolib fbrt0.o`, `-nolib fbrt0pic.o`
- Since fbc 1.10.0.

See also

- [Compiler Option: -nodeflibs](Compiler-Option-Nodeflibs)
- [Using the Command Line](Fbc-Command-Line)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

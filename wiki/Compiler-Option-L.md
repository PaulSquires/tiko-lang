[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -l**

# Compiler Option: -l

Add a library file to the linker's list.

Syntax

`-l < libname >`

Parameters

`libname`

Name of the library to link in. The library file name's extension should not be included. For example, when using `-l something`, the linker will look for the files:

Description

The `-l` compiler option adds a library file to the linker's list, to be linked into the final executable or library if needed to satisfy dependencies.

See also

- [`#inclib`](Inclib)
- [Compiler Option: -p](Compiler-Option-P)
- [Using the Command Line](Fbc-Command-Line)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

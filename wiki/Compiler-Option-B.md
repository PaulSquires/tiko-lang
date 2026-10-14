[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -b**

# Compiler Option: -b

Add a source file to compilation

Syntax

`[ -b ] < source file >`

Parameters

`source file`

The name with extension, and optionally a path, of the basic source file.

Description

The `-b` option adds a source file to the compilation list. In general, this option is redundant since source files with a *.bas* extension can be specified without it, but is useful if a source file does not have a *.bas* extension, or if exists in an other directory.

 To compile and link the source files *file1.bas*, *file2.bas* and *file3.fb* into an executable (*file1.exe* in DOS/Windows, *file1* in Linux), type,

`fbc -b file1.bas file2.bas -b file3.fb`

Note that the `-b` option was not needed for *file1.bas* or *file2.bas*.

See also

- [Compiler Option: -a](Compiler-Option-a)
- [Using the Command Line](Quick-Start#compile-a-program)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

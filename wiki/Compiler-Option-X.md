[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -x**

# Compiler Option: -x

Set executable/library path/name

Syntax

`-x < name >`

Parameters

`name`

Name of the executable or library file.

Description

The `-x` compiler option set the executable or library name, with extension. Defaults to the name of the first source file passed on the command line. When compiling libraries, be sure to add the "lib" prefix to the file name, otherwise the linker will not be able to find it. If compiling and linking separately, this option must be set only in the linker.

See also

- [Using the Command Line](Fbc-Command-Line)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

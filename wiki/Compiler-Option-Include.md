[Home](Home) › **Compiler Option: -include**

# Compiler Option: -include

Include a header file on each source compiled

Syntax

`-include < include file >`

Parameters

`include file`

The header file name with extension, and optionally a path, to include.

Description

The `-include` option has the effect of adding an [`#include`](procedures-Include) preprocessor directive to the very beginning of each source file before processing it. When used multiple times, the files will be included in the order they are listed on the command-line.

 To include the file *header.bi* when processing *file1.bas* and *file2.bas*, type,

`fbc -include header.bi file1.bas file2.bas`

See also

- [`#include`](procedures-Include)
- [Compiler Option: -i](Compiler-Option-I)
- [Header Files](Header-Files-Bi)
- [Using the Command Line](Quick-Start#compile-a-program)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

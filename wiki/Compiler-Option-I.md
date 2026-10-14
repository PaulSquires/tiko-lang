[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -i**

# Compiler Option: -i

Add a path to search for include files

Syntax

`-i < include path >`

Parameters

`include path`

The directory path, relative or absolute, of where to search for include files.

Description

The `-i` option allows an additional directory to be used when searching for header files. By default, the compiler searches in the current directory, and *prefix*/inc--in that order--where, *prefix* is the location where FreeBASIC is installed. A directory specified with the `-i` option will be searched before these default directories, and when the `-i` option is used multiple times, the compiler will search the directories in the order they are listed on the command-line.

 To search in the subdirectory *includes* first for header files while compiling the source file *file.bas*, type,

`fbc -i includes file.bas`

See also

- [`#include`](procedures-Include)
- [Compiler Option: -include](Compiler-Option-Include)
- [Header Files](Header-Files-Bi)
- [Using the Command Line](Quick-Start#compile-a-program)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

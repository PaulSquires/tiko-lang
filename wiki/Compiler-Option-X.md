[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -x**

# Compiler Option: -x

> **In tiko.** tiko takes `-x` as fbc does, measured against fbc-modern 1.20: the linked executable, DLL or library is written to the path as given, with no extension added; `-x` may stand anywhere on the line, the last one wins, and it wins over `-o`; with `-c` it is ignored and each object keeps its own name; a `#cmdline "-x ..."` in the source wins over the command line's; `-x` with no name is `TKO0101`. tiko's `-o` names the linked output too, when there is no `-x`. In a `tiko.toml` target's `options`, the path is relative to `tiko.toml` ([tiko build](Category-Tiko-Build)).

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

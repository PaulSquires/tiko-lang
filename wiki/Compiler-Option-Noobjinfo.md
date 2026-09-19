[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -noobjinfo**

# Compiler Option: -noobjinfo

Do not read/write compile-time info from/to .o and .a files

Syntax

`-noobjinfo`

Description

The `-noobjinfo` compiler option disables the writing/reading of compile-time library and other linking options from/to .o and .a files. This also disables the use of fbextra.x (the supplemental linker script) for discarding the .fbctinf sections, which is useful when using the gold linker that doesn't support this kind of linker script.

Version

- Since fbc 1.06.0

See also

- [Using the Command Line](Fbc-Command-Line)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -maxerr**

# Compiler Option: -maxerr

Set maximum number of errors to report before aborting compilation

Syntax

`-maxerr < value | "inf" >`

Parameters

`value | "inf"`

Specifies the maximum number of errors or no maximum if "inf" is given instead of a value.

Description

The `-maxerr` compiler option sets the maximum number of errors the compiler must find before stopping. The default is 10. If **inf**, for infinite, is specified the compiler continues until it finds the end of the source. Useful if an IDE is parsing the error messages.  
 `-maxerr` only applies to compiler errors (therefore excluding compiler warnings, linker/assembler errors and other third party errors).

See also

- [Using the Command Line](Fbc-Command-Line)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -r**

# Compiler Option: -r

Compile into `*.asm/*.c/*.ll` file(s) only, do not assemble or link

Syntax

`-r`

Description

The `-r` option specifies that any source files listed are to be compiled to `*.asm`/`*.c`/`*.ll` files, depending on the used [code generation backend](Compiler-Option-Gen), and not compiled or linked into an executable.

 When using the `-r` option, [`-m`](Compiler-Option-M) must be specified when compiling the main module.

 Use the [`-R`](Compiler-Option-R-2) option to preserve intermediate files without affecting compilation/assembling/linking.  
 Use the [`-rr`](Compiler-Option-Rr) option to compile input source files to `*.asm` regardless of the code generation backend.

See also

- [Compiler Option: -c](Compiler-Option-C)
- [Compiler Option: -R](Compiler-Option-R-2)
- [Compiler Option: -m](Compiler-Option-M)
- [Compiler Option: -gen](Compiler-Option-Gen)
- [Compiler Option: -rr](Compiler-Option-Rr)
- [Using the Command Line](Fbc-Command-Line)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

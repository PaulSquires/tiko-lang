[Home](Home) › **Compiler Option: -rr**

# Compiler Option: -rr

Compile into `*.asm` file(s) only, do not assemble or link

Syntax

`-rr`

Description

The `-rr` option specifies that any source files listed are to be compiled to `*.asm` files, and not compiled or linked into an executable. Unlike with the [`-r`](Compiler-Option-R) option, this works regardless of the used [code generation backend](Compiler-Option-Gen).

 When using the `-rr` option, [`-m`](Compiler-Option-M) must be specified when compiling a main source file.

 Use the [`-RR`](Compiler-Option-Rr-2) option to preserve the generated `*.asm` files without affecting compilation/assembling/linking.

See also

- [Compiler Option: -c](Compiler-Option-C)
- [Compiler Option: -r](Compiler-Option-R)
- [Compiler Option: -RR](Compiler-Option-Rr-2)
- [Compiler Option: -m](Compiler-Option-M)
- [Compiler Option: -gen](Compiler-Option-Gen)
- [Using the Command Line](Quick-Start#compile-a-program)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

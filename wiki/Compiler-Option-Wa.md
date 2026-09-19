[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -Wa**

# Compiler Option: -Wa

Pass options to the assembler when using the assembly emitter (-gen gas).

Syntax

`-Wa < options >`

Parameters

`options`

Additional options to pass to the assembler.

Description

The `-Wa` compiler option passes additional options to GAS, the assembler. Options must be separated by commas only. The `-Wa` compiler option may be specified multiple times on the command line.

 For example:

`fbc -Wa -o,output.o,--verbose`  
 `fbc -Wa -o -Wa output.o -Wa --verbose`

See also

- [Compiler Option: -gen](Compiler-Option-Gen)
- [Compiler Option: -Wc](Compiler-Option-Wc)
- [Compiler Option: -Wl](Compiler-Option-Wl)
- [Using the Command Line](Fbc-Command-Line)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

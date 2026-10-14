[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -pp**

# Compiler Option: -pp

Emit the preprocessed input file only, do not compile

Syntax

`-pp`

Description

The `-pp` compiler option enables the preprocessor-only mode. The code is parsed & checked as usual, but is not compiled. For every input file \<source>.bas passed to the compiler, a pre-processed version named \<source>.pp.bas is generated.  
 Specifically, preprocessor commands such as conditional compilation (#if, #ifdef, #ifndef, etc.), text replacement (#define, #macro, etc.) and file inclusion (#include) are processed recursively, and the resulting expanded code is written to the pp.bas file.

See also

- [Using the Command Line](Quick-Start#compile-a-program)
- [Preprocessor commands](Preprocessor)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

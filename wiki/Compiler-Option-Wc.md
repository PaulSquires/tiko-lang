[Home](Home) › **Compiler Option: -Wc**

# Compiler Option: -Wc

Pass options to the C compiler when using the C emitter (-gen gcc).

Syntax

`-Wc < options >`

Parameters

`options`

Additional options to pass to the C compiler.

Description

The `-Wc` compiler option passes additional options to GCC, the C compiler. Options must be separated by commas only. The -Wc compiler option may be specified multiple times on the command line.

 For example:

`fbc -gen gcc -Wc -m32,--verbose,-include,some-header.h`  
 `fbc -gen gcc -Wc -m32 -Wc --verbose -Wc -include -Wc some-header.h`

See also

- [Compiler Option: -gen](Compiler-Option-Gen)
- [Compiler Option: -Wa](Compiler-Option-Wa)
- [Compiler Option: -Wl](Compiler-Option-Wl)
- [Using the Command Line](Quick-Start#compile-a-program)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

[Home](Home) › **Compiler Option: -vec**

# Compiler Option: -vec

Enables vector optimizations by the compiler.

Syntax

`-vec < level >`

Parameters

`level`

The level of vectorization: (`0` | `NONE`) | `1` | `2`.

Description

The `-vec` compiler option enables multiple levels of optimizations by searching for multiple scalar expressions that can be merged into a single vector expression. If this option is not specified, the default is `-vec 0`.

 `-vec 0` | `none` will disable vector optimizations.

 `-vec 1` will enable complete expression merging vectorization.

 `-vec 2` includes `-vec 1` but also enables intra-expression vectorization.

 This option is dependent on the `-fpu SSE` command line option. Attempting to enable vector optimizations without using `-fpu SSE` will generate an error.

See also

- [Using the Command Line](Quick-Start#compile-a-program)
- [Compiler option -fpu](Compiler-Option-Fpu)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

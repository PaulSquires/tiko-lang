[Home](Home) › **Compiler Option: -fpmode**

# Compiler Option: -fpmode

Selects faster, less accurate or slower, more precise floating-point math.

Syntax

`-fpmode < mode >`

Parameters

`mode`

The floating point mode: `FAST` | `PRECISE`.

Description

The `-fpmode` compiler option specifies whether speed or precision is more important for floating point math. If this option is not specified, the default is `-fpmode PRECISE`.

 `-fpmode FAST` will generate faster, less accurate instructions for certain floating point operations.

 `-fpmode PRECISE` will generate standard floating point instructions that operate at the default speed and accuracy of the selected floating point unit.

 Currently, the only floating point operations that behave differently when using `-fpmode FAST` are: `Sin()`, `Cos()`, reciprocal, and reciprocal [Square Root](Sqr), all of which must operate on [`Single`](Single) precision values.

 A number of changes were made to normalize handling of NaN's (Not a Number) to get consistent results across toolchains and platforms, but that costs extra code, so intention was that `-fpmode FAST` could allow user to skip that extra code generation if they wanted (and they assume responsibility how things work or do not work across platforms).

 **Note:**

**-** for x86 and x86_64, default is `-fpu x87 -fpmode PRECISE`
 **-** `-fpmode FAST|PRECISE` controls code generation by the compiler only
 **-** for optimizing with '-gen gcc' backend, use '-Wc -ffast-math'

See also

- [Using the Command Line](Quick-Start#compile-a-program)
- [Compiler Option: -fpu](Compiler-Option-Fpu)
- [`__FB_FPMODE__`](Fb-Fpmode)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

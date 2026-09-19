[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -fpu**

# Compiler Option: -fpu

Sets the math unit to be used for floating point arithmetic.

Syntax

`-fpu < type >`

Parameters

`type`

The floating point unit: `X87` | `SSE` | `NEON`.

Description

The `-fpu` compiler option sets the math unit to be used for floating point arithmetic. If this option is not specified, the default is `-fpu X87`.

 `-fpu X87` will generate floating point instructions for the 387.

 `-fpu SSE` will generate floating point instructions for SSE and SSE2 with some math support still done by the 387.

 `-fpu NEON` will generate floating point instructions for `ARMv7-A` Advanced SIMD (Neon) extension. Specifying this option will automatically set the arch to at least `armv7-a` if not already set to a later processor.

 Functions normally return a floating point value ([`Single`](Single) or [`Double`](Double)) in the `st(0)` register. Sometimes, this may be optimized by returning the value in the `xmm0` register instead. This can be specified with [`Option("Sse")`](Option) after the return type in a function's declaration or definition. [`Option("Sse")`](Option) is ignored unless the source is compiled with the `-fpu SSE` command line option.

Version

- `-fpu NEON` added in fbc-1.20.0

See also

- [Using the Command Line](Fbc-Command-Line)
- [`Option()`](Option)
- [`__FB_FPU__`](Fb-Fpu)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

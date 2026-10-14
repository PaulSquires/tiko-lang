[Home](Home) › **Compiler Option: -g**

# Compiler Option: -g

Add debug information, define `__FB_DEBUG__`, and enable asserts

Syntax

`-g`

Description

The `-g` compiler option inserts debugging symbols into output files, to use with GDB-compatible debuggers.

 The intrinsic macro [`__FB_DEBUG__`](Fb-Debug) is set to non-zero (-1) if the option was specified, and set to zero (0) otherwise.

 [`Assert`](Assert) and [`AssertWarn`](Assertwarn) macros are enabled.

 Use of `-g` automatically implies [`-edebug`](Compiler-Option-Edebug), [`-edebuginfo`](Compiler-Option-Edebuginfo), and [`-eassert`](Compiler-Option-Eassert), command line options.

 [`__FB_ERR__`](Fb-Err) can be used to determine in user source code if the `-g` option was specified or implied on the command line.

See also

- [`__FB_DEBUG__`](Fb-Debug)
- [`__FB_ERR__`](Fb-Err)
- [`Assert`](Assert)
- [`AssertWarn`](Assertwarn)
- [Compiler Option: -eassert](Compiler-Option-Eassert)
- [Compiler Option: -debug](Compiler-Option-Edebug)
- [Compiler Option: -debuginfo](Compiler-Option-Edebuginfo)
- [Debugging](Debugging)
- [Using the Command Line](Quick-Start#compile-a-program)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

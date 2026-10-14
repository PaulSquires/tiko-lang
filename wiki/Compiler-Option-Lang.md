[Home](Home) › **Compiler Option: -lang**

# Compiler Option: -lang

Provides QuickBASIC or backward compatibility

Syntax

`-lang dialect`

Parameters

`dialect`

The dialect to use in compilation, one of `fb` (default), `fblite`, `qb` or `deprecated`.

Description

The `-lang` compiler option changes the way source code is interpreted, and is meant as a tool to users wanting traditional QuickBASIC-like behavior, or behavior deprecated from previous versions of FreeBASIC.

 The intrinsic macro [`__FB_LANG__`](Fb-Lang) is set to the string name of the dialect specified on the command line, or `"fb"` by default.

 To learn more about the differences between each of these language dialects, see [Compiler Dialects](Freebasic-Dialects).

 **fb**

This is the default dialect, and allows compilation of source code adhering to the most recent version of the FreeBASIC language.

**fblite**

This dialect provides support for FreeBASIC syntax and functionality, but with a more traditional QuickBASIC programming style.

**qb**

This dialect provides the best support for older QuickBASIC code.

**deprecated**

This dialect is for backward compatibility with some previous versions of FreeBASIC, however, this dialect may not exist in future versions. Programmers should consider using the "fblite" dialect instead.

Note: this command-line option can be overridden by any [`#lang`](procedures-Lang) statements used in the code.

See also

- [`#lang`](procedures-Lang)
- [`__FB_LANG__`](Fb-Lang)
- [Compiler Option: -forcelang](Compiler-Option-Forcelang)
- [Compiler Dialects](Freebasic-Dialects)
- [Using the Command Line](Quick-Start#compile-a-program)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

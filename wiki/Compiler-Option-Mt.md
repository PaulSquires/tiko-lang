[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -mt**

# Compiler Option: -mt

Link with thread-safe runtime library

Syntax

`-mt`

Description

The `-mt` compiler option forces linking with thread-safe runtime library for multithreaded applications. The thread-safe version is always used automatically if the FreeBASIC built-in threading functions are used, so you only need to specify this option if using your own threading routines.

 The intrinsic macro [`__FB_MT__`](Fb-Mt) is set to non-zero (-1) if the `-mt` option was specified, or whether one of the [`Threadtcreate`](Threadcreate) or [`ThreadCall`](Threadcall) keywords is used more above in the source code. Otherwise, it is set to zero (0).

See also

- [`__FB_MT__`](Fb-Mt)
- [Using the Command Line](Fbc-Command-Line)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

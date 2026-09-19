[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -edebuginfo**

# Compiler Option: -edebuginfo

Add debug information

Syntax

`-edebuginfo`

Description

The `-edebuginfo` compiler inserts debugging symbols into output files, to use with GDB-compatible debuggers.

 `-edebuginfo` is automatically implied by the [`-g`](Compiler-Option-G) option.

 [`__FB_ERR__`](Fb-Err) can be used to determine in user source code if the `-edebugingo` option was specified or implied on the command line.

Version

- Since fbc 1.07.0

See also

- [`__FB_ERR__`](Fb-Err)
- [Compiler Option: -g](Compiler-Option-G)
- [Debugging](Debugging)
- [Using the Command Line](Fbc-Command-Line)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -s**

# Compiler Option: -s

Sets the executable subsystem

Syntax

`-s < subsystem >`

Parameters

`subsystem`

The executable subsystem: `gui` or `console`.

Description

The `-s` compiler option specifies the executable subsystem. Allowed subsystems are `gui` and `console` (by default, `console` is used). Specifying a `gui` subsystem prevents the console window from appearing behind the program window.

 The intrinsic macro [`__FB_GUI__`](Fb-Gui) is set to non-zero (-1) if the option with `gui` as subsystem was specified, and set to zero (0) otherwise.

Platform Differences

- Supported on Windows and Cygwin only.

See also

- [`__FB_GUI__`](Fb-Gui)
- [Using the Command Line](Quick-Start#compile-a-program)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -nostrip**

# Compiler Option: -nostrip

Do not strip symbol information from the output file

Syntax

`-nostrip`

Description

The `-nostrip` compiler option explicitly prevents fbc from passing the option to strip (remove) all symbols to the linker. Object modules and libraries will retain any symbols present after linking.

Version

- Since fbc 1.07.0

Platform Differences

- fbc strips all symbols by default on Dos and Windows platforms only

See also

- [-strip](Compiler-Option-Strip)
- [Using the Command Line](Fbc-Command-Line)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

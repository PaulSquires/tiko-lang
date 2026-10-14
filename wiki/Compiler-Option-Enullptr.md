[Home](Home) › **Compiler Option: -enullptr**

# Compiler Option: -enullptr

Enable null-pointer checking

Syntax

`-enullptr`

Description

The `-enullptr` compiler option enables null-pointer error checking in run-time code generation. A run-time error is generated if an attempt is made to dereference a null-pointer to a value, or call a null function pointer.

 `-enullptr` is automatically implied by the [`-exx`](Compiler-Option-Exx) option.

 [`__FB_ERR__`](Fb-Err) can be used to determine in user source code if the `-enullptr` option was specified or implied on the command line.

Version


See also

- [`__FB_ERR__`](Fb-Err)
- [Compiler Option: -exx](Compiler-Option-Exx)
- [Error Handling](Error-Handling)
- [Using the Command Line](Quick-Start#compile-a-program)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

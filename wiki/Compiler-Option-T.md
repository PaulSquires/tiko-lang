[Home](Home) › **Compiler Option: -t**

# Compiler Option: -t

Set stack size in kilobytes

Syntax

`-t < stack size >`

Parameters

`stack size`

Stack size in kilobytes.

Description

The `-t` compiler option sets the stack size in kilobytes (defaults to 1024 KBytes for 32-bit targets, and 2048 KBytes for 64-bit targets). The local arrays are created in the stack, so 1 MB or 2 MB of stack is not always enough.

Version


Platform Differences

- Supported on Windows, Cygwin and DOS only.

See also

- [Using the Command Line](Quick-Start#compile-a-program)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

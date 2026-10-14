[Home](Home) › [Preprocessor](Category-Preprocessor) › **#inclib**

# #inclib

Preprocessor directive

## Syntax

```freebasic
#inclib "libname"
```

## Description

Includes a library in the linking process as if the user specified [`-l libname`](Compiler-Option-L) on the command line.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`#include`](procedures-Include)
- [Compiler Option: -l](Compiler-Option-L)
- [Compiler Option: -p](Compiler-Option-P)

## Examples

```freebasic
'' incomplete code snippet

'' this will include libmystuff.a in the link process

#inclib "mystuff"
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

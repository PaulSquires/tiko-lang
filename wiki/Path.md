[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__PATH__**

# __PATH__

Intrinsic define (macro string) set by the compiler

## Syntax

```freebasic
__PATH__
```

## Description

Set to the quoted absolute path of the source file at the time of compilation.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FILE__`](File)

## Examples

```freebasic
' Tell the compiler to seach the source file's

' directory for libraries

#libpath __PATH__
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

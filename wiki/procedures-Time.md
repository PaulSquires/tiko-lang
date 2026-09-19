[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__TIME__**

# __TIME__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__TIME__
```

## Description

Substitutes the compiler time in a literal string (24 clock, `"hh:mm:ss"` format) where used.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__DATE__`](procedures-Date)
- [`__DATE_ISO__`](Date-Iso)
- [`Time`](Time)

## Examples

`Print "Compile Time: " & __TIME__`

```freebasic
Compile Time: 13:42:57
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__DATE__**

# __DATE__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__DATE__
```

## Description

Substitutes the compiler date in a literal string (`"mm-dd-yyyy"` format) where used.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__DATE_ISO__`](Date-Iso)
- [`__TIME__`](procedures-Time)
- [`Date`](Date)

## Examples

`Print "Compile Date: " & __DATE__`

```freebasic
Compile Date: 09-29-2011
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

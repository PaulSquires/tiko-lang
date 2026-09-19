[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__DATE_ISO__**

# __DATE_ISO__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__DATE_ISO__
```

## Description

Substitutes the compiler date in a literal string (`"yyyy-mm-dd"` format) where used. This format is in line with ISO 8601 and can be used for lexicographical date comparisons.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__DATE__`](procedures-Date)
- [`__TIME__`](procedures-Time)
- [`Date`](Date)

## Examples

```freebasic
Print "Compile Date: " & __DATE_ISO__

If __DATE_ISO__ < "2011-12-25" Then

    Print "Compiled before Christmas day 2011"

Else

    Print "Compiled after Christmas day 2011"

End If
```

```freebasic
Compile Date: 2011-09-29
Compiled before Christmas day 2011
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

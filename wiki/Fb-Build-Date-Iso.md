[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_BUILD_DATE_ISO__**

# __FB_BUILD_DATE_ISO__

Intrinsic define (macro string) set by the compiler

## Syntax

```freebasic
__FB_BUILD_DATE_ISO__
```

## Description

Substituted with the quoted string containing the date (`YYYY-MM-DD`) the compiler was built on in ISO date format.

## Remarks

### Version

- Since fbc 1.07.1

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_BUILD_DATE__`](Fb-Build-Date)
- [`__DATE__`](procedures-Date)
- [`__DATE_ISO__`](Date-Iso)

## Examples

`Print "This program compiled with a compiler built on this date:" & __FB_BUILD_DATE_ISO__`

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

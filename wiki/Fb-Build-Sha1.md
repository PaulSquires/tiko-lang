[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_BUILD_SHA1__**

# __FB_BUILD_SHA1__

Intrinsic define (macro string) set by the compiler

## Syntax

```freebasic
__FB_BUILD_SHA1__
```

## Description

Substituted by a string of the compiler's source SHA-1 revision. The value is set using the SHA-1 commit id of the source code revision used to build the compiler binary, if available. If the SHA-1 was not available at the time of building the compiler, the value will be an empty string.

## Remarks

### Version

- Since fbc 1.07.1

### Differences from QB

- New to FreeBASIC

## Examples

`Print __FB_BUILD_SHA1__`

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

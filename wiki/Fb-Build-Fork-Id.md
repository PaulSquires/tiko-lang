[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_BUILD_FORK_ID__**

# __FB_BUILD_FORK_ID__

Intrinsic define (macro string) set by the compiler

## Syntax

```freebasic
__FB_BUILD_FORK_ID__
```

## Description

Substituted by a string of the compiler's custom defined project fork identifier name if defined at the compiler's build time, or an empty string if it was not defined.

 This value is an empty string for releases made by the FreeBASIC Development Team. Community developers and experimenters may define this value when building their own compiler packages using the makefile to help users identify that the compiler may be a special build and may have specific features not in the main release packages.

## Remarks

### Differences from QB

- New to FreeBASIC

## Examples

`Print "fbc fork id: "; __FB_BUILD_FORK_ID__`

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

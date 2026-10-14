[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_OPTION_EXPLICIT__**

# __FB_OPTION_EXPLICIT__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_OPTION_EXPLICIT__
```

## Description

`__FB_OPTION_EXPLICIT__` indicates if `Option Explicit` has been used previously in the source.

 Returns zero (0) if the option has not been set. Returns non-zero (-1) if the option has been set.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Dim`](Dim)

## Examples

```freebasic
#if( __FB_OPTION_EXPLICIT__ = 0 )

  #error Option Explicit must used With This module

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

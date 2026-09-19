[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_OPTION_DYNAMIC__**

# __FB_OPTION_DYNAMIC__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_OPTION_DYNAMIC__
```

## Description

`__FB_OPTION_DYNAMIC__` is defined as true (negative one (-1)) if a recent [`Option Dynamic`](Option-Dynamic) statement or [`'$Dynamic`](Dynamic) meta-command was issued. Otherwise, it is defined as zero (0).

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Option Dynamic`](Option-Dynamic)
- [`Option Static`](Option-Static)

## Examples

```freebasic
#if __FB_OPTION_DYNAMIC__ <> 0

#error This module must Not use Option Dynamic

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

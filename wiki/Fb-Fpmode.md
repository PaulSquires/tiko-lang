[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_FPMODE__**

# __FB_FPMODE__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_FPMODE__
```

## Description

Defined as `"fast"` if SSE fast arithmetics is enabled, or `"precise"` otherwise.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [Compiler Option: -fpmode](Compiler-Option-Fpmode)

## Examples

```freebasic
#if __FB_FPMODE__ = "fast"

  ' ... instructions for using fast-mode math ...

#else

  ' ... instructions for using normal math ...

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

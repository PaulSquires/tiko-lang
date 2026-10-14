[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_FPU__**

# __FB_FPU__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_FPU__
```

## Description

For `x86` and `x86_64` targets:

For `arm` and `aarch64` targets:

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_SSE__`](Fb-Sse)
- [Compiler Option: -fpu](Compiler-Option-Fpu)

## Examples

```freebasic
#if __FB_FPU__ = "sse"

  ' ... instructions only for SSE ...

#else

  ' ... instructions not for SSE ...

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

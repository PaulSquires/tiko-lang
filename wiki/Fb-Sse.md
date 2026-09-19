[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_SSE__**

# __FB_SSE__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_SSE__
```

## Description

Define without a value created at compile time if SSE floating point arithmetics is enabled.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_FPU__`](Fb-Fpu)
- [Compiler Option: -fpu](Compiler-Option-Fpu)

## Examples

```freebasic
#ifdef __FB_SSE__

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

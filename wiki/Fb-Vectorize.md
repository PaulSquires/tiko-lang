[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_VECTORIZE__**

# __FB_VECTORIZE__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_VECTORIZE__
```

## Description

Defined as the vectorisation level number set by the *[-vec](Compiler-Option-Vec)* command-line option.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [Compiler Option: -vec](Compiler-Option-Vec)

## Examples

```freebasic
#if __FB_VECTORIZE__ = 2

  ' ... instructions only for vectorization level 2...

#else

  ' ...

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

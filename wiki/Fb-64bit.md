[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_64BIT__**

# __FB_64BIT__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_64BIT__
```

## Description

Define created at compile time if the the compilation target is 64bit, otherwise undefined.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_LINUX__`](Fb-Linux)
- [`__FB_FREEBSD__`](Fb-Freebsd)
- [`__FB_OPENBSD__`](Fb-Openbsd)
- [`__FB_NETBSD__`](Fb-Netbsd)
- [`__FB_CYGWIN__`](Fb-Cygwin)
- [`__FB_DARWIN__`](Fb-Darwin)
- [`__FB_PCOS__`](Fb-Pcos)
- [Compiler Option: -target](Compiler-Option-Target)

## Examples

```freebasic
#ifdef __FB_64BIT__

  '...instructions for 64bit OSes...

#else

  '...instructions for other OSes

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

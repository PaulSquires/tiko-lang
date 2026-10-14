[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_LANG__**

# __FB_LANG__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_LANG__
```

## Description

`__FB_LANG__` indicates which language compatibility option was set at the time of compilation of a module. By default `__FB_LANG__` will be set to `"fb"`. The language compatibility option can be changed using one (or more) of the following methods:

Returns a lower case string with one of the following values:

| value | description |
| --- | --- |
| ''fb'' | FreeBASIC compatibility (default) |
| ''qb'' | QBASIC compatibility |
| ''fblite'' | FreeBASIC language compatibility, with a more QBASIC-compatible coding style |
| ''deprecated'' | older compiler version compatibility |

`__FB_LANG__` is always defined.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_VERSION__`](Fb-Version)
- [`#lang`](procedures-Lang)
- [Compiler Option: -lang](Compiler-Option-Lang)
- [Compiler Option: -forcelang](Compiler-Option-Forcelang)
- [Compiler Dialects](Freebasic-Dialects)

## Examples

```freebasic
'' Set option explicit always on

#ifdef __FB_LANG__

  #if __FB_LANG__ <> "fb"

    Option Explicit

  #endif

#else

  '' Older version - before lang fb

  Option Explicit

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

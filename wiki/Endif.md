[Home](Home) › [Preprocessor](Category-Preprocessor) › **#endif**

# #endif

Preprocessor conditional directive

## Syntax

```freebasic
#endif
```

## Description

Ends a group of conditional directives

 See [`#if`](If), [`#ifdef`](Ifdef), or [`#ifndef`](Ifndef) for examples of usage.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`#define`](Define)
- [`#macro`](Macro-Endmacro)
- [`#if`](If)
- [`#else`](procedures-Else)
- [`#elseif`](procedures-Elseif)
- [`#elseifdef`](Elseifdef)
- [`#elseifndef`](Elseifndef)
- [`#ifdef`](Ifdef)
- [`#ifndef`](Ifndef)
- [`#undef`](Undef)
- [`defined`](Defined)

## Examples

```freebasic
#define DEBUG_LEVEL 1

#if (DEBUG_LEVEL = 1)

  'Conditional statements

#endif
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

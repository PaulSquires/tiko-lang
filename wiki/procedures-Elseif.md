[Home](Home) › [Preprocessor](Category-Preprocessor) › **#elseif**

# #elseif

Preprocessor conditional directive

## Syntax

```freebasic
#if (expression1)
' Conditionally included statements if expression1 is True
#elseif (expression2)
' Conditionally included statements if expression2 is True
#else
' Conditionally included statements if both
' expression1 and expression2 are False
#endif
```

## Description

**#elseif** can be added to an [`#if`](If) block to provide an additional conditions.

## Remarks

### Differences from QB

- New to Freebasic

### See also

- [`#define`](Define)
- [`#macro`](Macro-Endmacro)
- [`#if`](If)
- [`#else`](procedures-Else)
- [`#elseifdef`](Elseifdef)
- [`#elseifndef`](Elseifndef)
- [`#endif`](Endif)
- [`#ifdef`](Ifdef)
- [`#ifndef`](Ifndef)
- [`#undef`](Undef)
- [`defined`](Defined)

## Examples

```freebasic
#define WORDSIZE 16

#if (WORDSIZE = 16)

  ' Do some some 16 bit stuff

#elseif (WORDSIZE = 32)

  ' Do some some 32 bit stuff

#else

  #error WORDSIZE must be set To 16 Or 32

#endif
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

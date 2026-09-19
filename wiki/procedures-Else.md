[Home](Home) › [Preprocessor](Category-Preprocessor) › **#else**

# #else

Preprocessor conditional directive

## Syntax

```freebasic
#if (expression)
' Conditionally included statements if expression is True
#else
' Conditionally included statements if expression is False
#endif
```

## Description

**#else** can be added to an [`#if`](If), [`#ifdef`](Ifdef), or [`#ifndef`](Ifndef) block to provide an alternate result to the conditional expression.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`#define`](Define)
- [`#macro`](Macro-Endmacro)
- [`#if`](If)
- [`#elseif`](procedures-Elseif)
- [`#elseifdef`](Elseifdef)
- [`#elseifndef`](Elseifndef)
- [`#endif`](Endif)
- [`#ifdef`](Ifdef)
- [`#ifndef`](Ifndef)
- [`#undef`](Undef)
- [`defined`](Defined)

## Examples

```freebasic
#define MODULE_VERSION 1

Dim a As String

#if (MODULE_VERSION > 0)

  a = "Release"

#else

  a = "Beta"

#endif

Print "Program is "; a
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

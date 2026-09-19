[Home](Home) › [Preprocessor](Category-Preprocessor) › **#elseifndef**

# #elseifndef

Preprocessor conditional directive

## Syntax

```freebasic
#ifdef A
' Conditionally included statements if A is defined
#elseifndef B
' Conditionally included statements if both A and B are not defined
#else
' Conditionally included statements if A is not defined and B is defined
#endif
```

## Description

**#elseifndef** can be added to an [`#if`](If) block to provide an additional condition.

 `#elseifndef symbol` is equivalent to `#elseif Not defined(symbol)`

## Remarks

### Version

- Since fbc 1.20.0

### Differences from QB

- New to Freebasic

### See also

- [`#define`](Define)
- [`#macro`](Macro-Endmacro)
- [`#if`](If)
- [`#else`](procedures-Else)
- [`#elseif`](procedures-Elseif)
- [`#elseifdef`](Elseifdef)
- [`#endif`](Endif)
- [`#ifdef`](Ifdef)
- [`#ifndef`](Ifndef)
- [`#undef`](Undef)
- [`defined`](Defined)

## Examples

```freebasic
#ifdef A

    Print "A is defined"

#elseifndef B

    Print "both A and B are not defined"

#else

    Print "A is not defined and B is defined"

#endif
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

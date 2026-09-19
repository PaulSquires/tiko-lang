[Home](Home) › [Preprocessor](Category-Preprocessor) › **#ifdef**

# #ifdef

Preprocessor conditional directive

## Syntax

```freebasic
#ifdef symbol
' Conditionally included statements
#endif
```

## Description

Conditionally includes statements at compile time.

 Statements within the `#ifdef...#endif` block are included if `symbol` is defined and excluded (ignored) if `symbol` is not defined.

 `#ifdef symbol` is equivalent to `#if defined (symbol)`

## Remarks

### Differences from QB

- New to Freebasic

### See also

- [`#define`](Define)
- [`#macro`](Macro-Endmacro)
- [`#if`](If)
- [`#else`](procedures-Else)
- [`#elseif`](procedures-Elseif)
- [`#elseifdef`](Elseifdef)
- [`#elseifndef`](Elseifndef)
- [`#endif`](Endif)
- [`#ifndef`](Ifndef)
- [`#undef`](Undef)
- [`defined`](Defined)

## Examples

```freebasic
#define _DEBUG

#ifdef _DEBUG

    ' Special statements for debugging

#endif
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

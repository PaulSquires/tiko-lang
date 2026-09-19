[Home](Home) › [Preprocessor](Category-Preprocessor) › **#ifndef**

# #ifndef

Preprocessor conditional directive

## Syntax

```freebasic
#ifndef symbol
' Conditionally included statements
#endif
```

## Description

Conditionally includes statements at compile time.

 Statements within the `#ifndef...#endif` block are included if `symbol` is not defined and excluded (ignored) if *symbol* is defined.

 `#ifndef symbol` is equivalent to `#if Not defined(symbol)`

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
- [`#endif`](Endif)
- [`#ifdef`](Ifdef)
- [`#undef`](Undef)
- [`defined`](Defined)

## Examples

```freebasic
#ifndef __MYFILE_BI__

#define __MYFILE_BI__

    ' Declarations

#endif
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

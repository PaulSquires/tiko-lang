[Home](Home) › [Preprocessor](Category-Preprocessor) › **#if**

# #if

Preprocessor conditional directive

## Syntax

```freebasic
#if (expression)
' Conditionally included statements
#endif
```

## Description

Conditionally includes statements at compile time.

 Statements contained within the `#if` / [`#endif`](Endif) block are included if `expression` evaluates to True (non-zero) and excluded (ignored) if `expression` evaluates to False (`0`).

 This conditional directive differs from the [`If`](If-Then) conditional statement in that `#if` is evaluated at compile-time and [`If`](If-Then) is evaluated at run-time.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`#define`](Define)
- [`#macro`](Macro-Endmacro)
- [`#else`](procedures-Else)
- [`#elseif`](procedures-Elseif)
- [`#elseifdef`](Elseifdef)
- [`#elseifndef`](Elseifndef)
- [`#endif`](Endif)
- [`#ifdef`](Ifdef)
- [`#ifndef`](Ifndef)
- [`#undef`](Undef)
- [`defined`](Defined)
- [`#assert`](procedures-Assert)

## Examples

```freebasic
#define DEBUG_LEVEL 1

#if (DEBUG_LEVEL >= 2)

  ' This line is not compiled since the expression is False

  Print "Starting application"

#endif
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

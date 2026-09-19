[Home](Home) › [Preprocessor](Category-Preprocessor) › **defined**

# defined

Preprocessor function to test if a symbol has been defined

## Syntax

```freebasic
defined (symbol_name)
```

## Parameters

- `symbol_name`

## Description

Given the symbol name, the `defined()` preprocessor function returns true if the symbol has been defined - or false if the symbol is unknown.

 This is used mainly with [`#if`](If) (or [`#elseif`](procedures-Elseif)).  
 Similar to [`#ifdef`](Ifdef) (or [`#elseifdef`](Elseifdef)) except it allows more than one check to occur because of its flexibility.

## Return Value

Returns non-zero (`-1`) if the symbol has been defined, otherwise returns zero (`0`).

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
- [`#ifndef`](Ifndef)
- [`#undef`](Undef)

## Examples

```freebasic
'e.g. - which symbols are defined out of a, b, c, and d ?

Const a = 300

#define b 12

Dim c As Single

#if defined(a)

 Print "a is defined"

#endif

#if defined(b)

 Print "b is defined"

#endif

#if defined(c)

 Print "c is defined"

#endif

#if defined(d)

 Print "d is defined"

#endif
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

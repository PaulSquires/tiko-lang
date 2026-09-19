[Home](Home) › [Preprocessor](Category-Preprocessor) › **#undef**

# #undef

Preprocessor directive to undefine a macro

## Syntax

```freebasic
#undef symbol
```

## Description

Undefines a symbol previously defined with [`#define`](Define).

 Can be used to ensure that a macro or symbol has a limited lifespan and does not conflict with a similar macro definition that may be defined later in the source code.

 (Note: `#undef` should not be used to undefine variable or function names used in the current function scope. The names are needed internally by the compiler and removing them can cause strange and unexpected results.)

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
- [`#ifdef`](Ifdef)
- [`#ifndef`](Ifndef)
- [`defined`](Defined)

## Examples

```freebasic
#define ADD2(a_, b_)  ((a_) + (b_))

Print ADD2(1, 2)

' Macro no longer needed so get rid of it ...

#undef ADD2
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

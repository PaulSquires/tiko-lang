[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_OPTION_ESCAPE__**

# __FB_OPTION_ESCAPE__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_OPTION_ESCAPE__
```

## Description

Indicates if by default, string literals are processed for escape characters when not explicitly prefixed with the [$ Operator](Operator-Non-Escaped-String-Literal) for non-escaped strings, or the [! Operator](Operator-Escaped-String-Literal) for escaped strings.

 The default method for processing string literals is set by usage of the *[-lang](Compiler-Option-Lang)* command line option during compilation or usage of `Option Escape` in the source file.

 `__FB_OPTION_ESCAPE__` returns zero (0) if the option has not been set. Returns non-zero (-1) if the option has been set.

## Remarks

### Differences from QB

- New to FreeBASIC

## Examples

```freebasic
#if( __FB_OPTION_ESCAPE__ <> 0 )

  #error Option Escape must Not be used With This include file

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

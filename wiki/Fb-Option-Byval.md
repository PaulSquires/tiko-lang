[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_OPTION_BYVAL__**

# __FB_OPTION_BYVAL__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_OPTION_BYVAL__
```

## Description

Indicates if parameters to a [`Function`](procedures-Function) or [`Sub`](Sub) are passed by reference as with [`ByRef`](Byref-Parameters), or by value as with [`ByVal`](Byval) by default when the by value / by reference specifier is not explicitly stated.

 `__FB_OPTION_BYVAL__` is set to non-zero (-1) if by default parameters are passed value, and zero (0) if by default parameters are passed by reference.

 The default for passing parameters by reference or by value is determined by the *[-lang](Compiler-Option-Lang)* command line option used during compilation or usage of [`Option ByVal`](Option-Byval) in the source file.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`ByVal`](Byval)
- [`ByRef`](Byref-Parameters)
- [`Option ByVal`](Option-Byval)

## Examples

```freebasic
#if( __FB_OPTION_BYVAL__ <> 0 )

  #error Option ByVal must Not be used With This source

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

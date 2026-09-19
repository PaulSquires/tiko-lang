[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_OPTION_PRIVATE__**

# __FB_OPTION_PRIVATE__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_OPTION_PRIVATE__
```

## Description

Indicates if by default [`Function`](procedures-Function)'s and [`Sub`](Sub)'s have module scope or global scope when not explicitly specified with [`Private`](Private) or [`Public`](Public).

 The default scope specifier for functions and subs is set by usage of the *[-lang](Compiler-Option-Lang)* command line option during compilation or usage of [`Option Private`](Option-Private) in the source file.

 Default scope of procedures can be changed during compilation with [`#Pragma Private`](Pragma).

 `__FB_OPTION_PRIVATE__` returns zero (0) if the option has not been set. Returns non-zero (-1) if the option has been set.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Option Private`](Option-Private)
- [`Private`](Private)
- [`Public`](Public)

## Examples

```freebasic
#if( __FB_OPTION_PRIVATE__ <> 0 )

  #error Option Private must Not be used With This module

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

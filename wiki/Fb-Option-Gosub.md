[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_OPTION_GOSUB__**

# __FB_OPTION_GOSUB__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_OPTION_GOSUB__
```

## Description

Indicates how [`GoSub`](Gosub) and `Return` will be handled at compile time. If the option is set (-1) then [`GoSub`](Gosub) is allowed and [`Return`](Return-From-Gosub) is recognized as return-from-gosub only. If the option is not set (0) then [`GoSub`](Gosub) is not allowed and [`Return`](Return-From-Procedure) is recognized as return-from-procedure only.

 This macro value can be changed at compile time. `Option Gosub` will set the option (enable gosub support) and `Option Nogosub` will clear the option (disable gosub support).

 `__FB_OPTION_GOSUB__` returns zero (0) if the option has not been set. Returns non-zero (-1) if the option has been set.

## Remarks

### Dialect Differences

- Defaults to `-1` in the *[-lang qb](Compiler-Option-Lang)* dialect and `0` in all other dialects.

### Differences from QB

- New to FreeBASIC

## Examples

```freebasic
#if( __FB_OPTION_GOSUB__ <> 0 )

    '' turn off gosub support

    Option nogosub

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

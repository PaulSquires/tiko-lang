[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **Option Gosub**

# Option Gosub

Enables support for GoSub and On Gosub.

## Syntax

```freebasic
Option Gosub
```

## Description

`Option Gosub` enables support for [`GoSub`](Gosub) and [`Return`](Return-From-Gosub) (from gosub).

 Because `Return` could mean return-from-gosub or return-from-procedure, `Option Gosub` and [`Option Nogosub`](Option-Nogosub) can be used to enable and disable [`GoSub`](Gosub) support. When [`GoSub`](Gosub) support is disabled, [`Return`](Return-From-Procedure) is then recognized as return-from-procedure.

## Remarks

### Dialect Differences

- Only available in the *[-lang fblite](Compiler-Option-Lang)* and *[-lang qb](Compiler-Option-Lang)* dialects.

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_OPTION_GOSUB__`](Fb-Option-Gosub)
- [`Option Nogosub`](Option-Nogosub)
- [`GoSub`](Gosub)
- [`Return (From Gosub)`](Return-From-Gosub)
- [`Return (From Procedure)`](Return-From-Procedure)

## Examples

```freebasic
'' Compile with the "-lang fblite" compiler switch

#lang "fblite"

'' turn on gosub support

Option GoSub

GoSub there

backagain:

    Print "backagain"

    End

there:

    Print "there"

    Return
```

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

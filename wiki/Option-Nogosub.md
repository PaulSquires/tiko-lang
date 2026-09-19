[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **Option Nogosub**

# Option Nogosub

Disables support for GoSub and On Gosub.

## Syntax

```freebasic
Option Nogosub
```

## Description

`Option Nogosub` disables support for [`GoSub`](Gosub) and [`Return`](Return-From-Gosub) (from gosub).

 Because `Return` could mean return-from-gosub or return-from-procedure, [`Option Gosub`](Option-Gosub) and `Option Nogosub` can be used to enable and disable [`GoSub`](Gosub) support. When [`GoSub`](Gosub) support is disabled, [`Return`](Return-From-Procedure) is then recognized as return-from-procedure.

## Remarks

### Dialect Differences

- Only available in the *[-lang fblite](Compiler-Option-Lang)* and *[-lang qb](Compiler-Option-Lang)* dialects.

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_OPTION_GOSUB__`](Fb-Option-Gosub)
- [`Option Gosub`](Option-Gosub)
- [`GoSub`](Gosub)
- [`Return (From Procedure)`](Return-From-Procedure)
- [`Return (From Gosub)`](Return-From-Gosub)

## Examples

```freebasic
'' Compile with the "-lang qb" compiler switch

'$lang: "qb"

'' turn off gosub support

Option nogosub

Function foo() As Integer

    Return 1234

End Function

Print foo
```

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

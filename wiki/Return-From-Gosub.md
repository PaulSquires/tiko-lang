[Home](Home) › [Control Flow Statements](Category-Control-Flow-Statements) › **Return (From Gosub)**

# Return (From Gosub)

Control flow statement to return from a procedure or GoSub.

## Syntax

```freebasic
Return [ label ]
```

## Description

`Return` is used to return from a gosub [`GoSub`](Gosub).

 Because `Return` could mean return-from-gosub or return-from-procedure, `Option Gosub` and `Option Nogosub` can be used to enable and disable [`GoSub`](Gosub) support. When [`GoSub`](Gosub) support is disabled, [`Return`](Return-From-Procedure) is then recognized as return-from-procedure. When [`GoSub`](Gosub) support is enabled, [`Return`](Return-From-Gosub) is then recognized as return-from-gosub.

 `Return` (from gosub) is used to return control back to the statement immediately following a previous [`GoSub`](Gosub) call. When used in combination with [`GoSub`](Gosub), no return value can be specified. If the optional `label` is specified, execution continues at the specified label. If no [`GoSub`](Gosub) was made, a runtime error is generated, and execution continues immediately after `Return`.

 A [`GoSub`](Gosub) should always have a matching `Return` statement. However, if `Return` (from gosub) is used where no [`GoSub`](Gosub) was made, a run-time error is generated.

## Remarks

### Dialect Differences

- In the *[-lang fb](Compiler-Option-Lang)* dialect `Return` always means return-from-procedure.
  In the *[-lang qb](Compiler-Option-Lang)* dialect, `Return` means return-from-gosub by default unless changed with `Option Nogosub`, in which case the compiler will recognize `Return` as return-from-procedure.  
  In the *[-lang fblite](Compiler-Option-Lang)* dialect, `Return` means return-from-procedure by default unless changed with `Option Gosub`, in which case the compiler will recognize `Return` as return-from-gosub.

### Differences from QB

- None when using the *[-lang qb](Compiler-Option-Lang)* dialect.

### See also

- [`Sub`](Sub)
- [`Function`](procedures-Function)
- [`GoSub`](Gosub)
- [`Return (From Procedure)`](Return-From-Procedure)

## Examples

```freebasic
'' GOSUB & RETURN example, compile with "-lang qb" or use "$lang" as below

'$lang: "qb"

Print "Let's Gosub!"

GoSub MyGosub

Print "Back from Gosub!"

Sleep

End

MyGosub:

Print "In Gosub!"

Return
```

---

**Category:** [Control Flow Statements](Category-Control-Flow-Statements)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

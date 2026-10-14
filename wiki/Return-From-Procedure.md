[Home](Home) › [Control Flow Statements](Category-Control-Flow-Statements) › **Return (From Procedure)**

# Return (From Procedure)

Control flow statement to return from a procedure or GoSub.

## Syntax

```freebasic
Return expression
```

## Description

`Return` is used to return from a procedure.

 Because `Return` could mean return-from-gosub or return-from-procedure, `Option Gosub` and `Option Nogosub` can be used to enable and disable [`GoSub`](Gosub) support. When [`GoSub`](Gosub) support is disabled, [`Return`](Return-From-Procedure) is then recognized as return-from-procedure. When [`GoSub`](Gosub) support is enabled, [`Return`](Return-From-Gosub) is then recognized as return-from-gosub.

 `Return` (from procedure) is used inside a procedure to exit the procedure possibly with a return value:

**Warning:** Whatever the output branch used, the return value must be always defined, otherwise an unexpected behavior may occur.

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
- [`Return (From Gosub)`](Return-From-Gosub)

## Examples

```freebasic
'' Return from function

Type rational              '' simple rational number type

    numerator As Integer

    denominator As Integer

End Type

'' multiplies two rational types

Function rational_multiply( r1 As rational, r2 As rational ) As rational

    Dim r As rational

    '' multiply the divisors ...

    r.numerator   = r1.numerator   * r2.numerator

    r.denominator = r1.denominator * r2.denominator

    '' ... and return the result

    Return r

End Function

Dim As rational r1 = ( 6, 105 )   '' define some rationals r1 and r2

Dim As rational r2 = ( 70, 4 )

Dim As rational r3

r3 = rational_multiply( r1, r2 )  '' multiply and store the result in r3

'' display the expression

Print r1.numerator & "/" & r1.denominator; " * ";

Print r2.numerator & "/" & r2.denominator; " = ";

Print r3.numerator & "/" & r3.denominator
```

---

**Category:** [Control Flow Statements](Category-Control-Flow-Statements)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

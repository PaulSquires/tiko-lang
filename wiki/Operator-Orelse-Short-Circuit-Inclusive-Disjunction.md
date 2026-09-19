[Home](Home) › [Operators](Category-Operators) › **Operator Orelse (Short Circuit Inclusive Disjunction)**

# Operator Orelse (Short Circuit Inclusive Disjunction)

Returns the short circuit-or (Inclusive Disjunction) of two numeric values

## Syntax

```freebasic
Declare Operator OrElse ( ByRef lhs As T1, ByRef rhs As T2 ) As Ret
```

## Parameters

- `lhs`
- `T1`
- `rhs`
- `T2`
- `Ret`
- `T1`
- `T2`

## Description

This operator evaluates the left hand side expression. If the result is nonzero, then `-1` (true) is immediately returned. If the result is zero then the right hand side is evaluated, and the logical result from that is returned, returning `-1` (true) for a nonzero value or `0` (false) for zero.  
 (for conversion of a boolean to an integer, false or true boolean value becomes 0 or -1 integer value)

 The truth table below demonstrates all combinations of a short circuit-or operation, the '-' denotes that the operand is not evaluated.

| Lhs Value | Rhs Value | Result |
| --- | --- | --- |
| 0 | 0 | 0 |
| 0 | nonzero | -1 |
| nonzero | (not evaluated) | -1 |

 **`OrElse`** equivalent to:
 `Iif( Lhs = 0, Rhs <> 0 , -1 )`

 Short-circuiting is performed - only expressions needed to calculate the result are evaluated. The left hand side `lhs` is evaluated first, and only if it evaluates to zero (false) is the right hand side `rhs` also evaluated. If the left hand side evaluation `lhs` returns non-zero (true), it is known that at that point that the overall condition is true, so the right hand side `rhs` is not evaluated (skipped).

 The return type is almost always an [`Integer`](Integer), of the value `0` or `-1`, denoting false and true respectively. Except if the left and right-hand side types are both [`Boolean`](Boolean), then the return type is also [`Boolean`](Boolean).

 This operator cannot be overloaded for user-defined types.

## Return Value

Returns the short circuit-or (inclusive disjunction) of the two operands.

## Remarks

### Usage

`result = lhs OrElse rhs`

### Differences from QB

- This operator was not available in QB.

### See also

- [`AndAlso`](Operator-Andalso-Short-Circuit-Conjunction)
- [`Or`](Operator-or-Inclusive-Disjunction)
- [Operator Truth Tables](Bitwise-Operators-Truth-Tables)

## Examples

```freebasic
'' Using the ORELSE operator to test

'' if a value is out of range

Dim As Integer n

Input "Enter a number between 1 and 10: ", n

Function test(ByVal n As Integer) As Integer

    Print "expression evaluated"

    Return n

End Function

'' print value only if n is in range [1, 10]

If test(n) < 1 OrElse test(n) > 10 Then  '' if n < 1, second expression is not evaluated

    Print "   => out of range"

Else

    Print "   => n ="; n

End If

Sleep
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

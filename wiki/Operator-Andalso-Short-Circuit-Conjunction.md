[Home](Home) › [Operators](Category-Operators) › **Operator Andalso (Short Circuit Conjunction)**

# Operator Andalso (Short Circuit Conjunction)

Returns the short circuit-and (conjunction) of two numeric values

## Syntax

```freebasic
Declare Operator AndAlso ( ByRef lhs As T1, ByRef rhs As T2 ) As Ret
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

This operator evaluates the left hand side expression. If the result is zero, then zero is immediately returned. If the result is nonzero then the right hand side is evaluated, and the logical result from that is returned.  
 (for conversion of a boolean to an integer, false or true boolean value becomes 0 or -1 integer value)

 The truth table below demonstrates all combinations of a short circuit-and operation, the '-' denotes that the operand is not evaluated.

| Lhs Value | Rhs Value | Result |
| --- | --- | --- |
| 0 | (not evaluated) | 0 |
| nonzero | 0 | 0 |
| nonzero | nonzero | -1 |

 **`AndAlso`** equivalent to:
 `Iif( Lhs <> 0, Rhs <> 0, 0 )`

 Short-circuiting is performed - only expressions needed to calculate the result are evaluated. The left hand side `lhs` is evaluated first, and only if it evaluates to non-zero (true) is the right hand side `rhs` also evaluated. If the left hand side evaluation `lhs` returns zero (false), it is known that at that point that the overall condition is false, so the right hand side `rhs` is not evaluated (skipped).

 The return type is almost always an [`Integer`](Integer), of the value `0` or `-1`, denoting false and true respectively. Except if the left and right-hand side types are both [`Boolean`](Boolean), then the return type is also [`Boolean`](Boolean).

 This operator cannot be overloaded for user-defined types.

## Return Value

Returns the short circuit-and (conjunction) of the two operands.

## Remarks

### Usage

`result = lhs AndAlso rhs`

### Differences from QB

- This operator was not available in QB.

### See also

- [`OrElse`](Operator-Orelse-Short-Circuit-Inclusive-Disjunction)
- [`And`](Operator-and-Conjunction)
- [Operator Truth Tables](Bitwise-Operators-Truth-Tables)

## Examples

```freebasic
'' Using the ANDALSO operator to guard against array access

'' when the index is out of range

Dim As Integer isprime(1 To 10) = { _

    _ ' 1  2  3  4  5  6  7  8  9  10    (2, 3, 5 and 7 are the only prime numbers)

        0, 1, 1, 0, 1, 0, 1, 0, 0, 0 _

    }

Dim As Integer n

Input "Enter a number between 1 and 10: ", n

'' isprime() array will only be accessed if n is in range

If (n >= 1 And n <= 10) AndAlso isprime(n) Then

    Print "n is prime"

Else

    Print "n is not prime, or out of range"

End If

Sleep
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

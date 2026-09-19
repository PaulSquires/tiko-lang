[Home](Home) › [Operators](Category-Operators) › **Operator Shr (Shift Right)**

# Operator Shr (Shift Right)

Shifts the bits of a numeric expression to the right

## Syntax

```freebasic
Declare Operator Shr ( ByRef lhs As Integer, ByRef rhs As Integer ) As Integer
Declare Operator Shr ( ByRef lhs As UInteger, ByRef rhs As UInteger ) As UInteger
Declare Operator Shr ( ByRef lhs As LongInt, ByRef rhs As LongInt ) As LongInt
Declare Operator Shr ( ByRef lhs As ULongInt, ByRef rhs As ULongInt ) As ULongInt
```

## Parameters

- `lhs`
- `rhs`

## Description

**`Operator Shr` (Shift right)** shifts all of the bits in the left-hand side expression (`lhs`) right a number of times specified by the right-hand side expression (`rhs`). Numerically, the result is the same as "`Int(lhs` [/](Operator-Divide) `2 ^ rhs)`". For example, "`&b0101 Shr 1`" returns the binary number `&b010`, and "`5 Shr 1`" returns `2`.

 If the left-hand side expression is signed and negative, the sign bit is copied in the newly created bits on the left after the shift. For example, "`-5 Shr 2`" returns `-2`.

 Neither of the operands are modified in any way.

 The results of this operation are undefined for values of `rhs` less than zero, or greater than or equal to the number of bits in the result's data type.

 This operator can be overloaded for user-defined types.

## Return Value

Returns the result of `lhs` being shifted right `rhs` number of times.

## Remarks

### Usage

`result = lhs Shr rhs`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Shr`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Operator Shr= (Shift Right And Assign)`](Operator-Shr-Shift-Right-and-Assign)
- [`Operator Shl (Shift Left)`](Operator-Shl-Shift-Left)
- [`Bin`](Bin)
- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
'Halve a number

For i As Integer = 0 To 10

    Print 1000 Shr i, Bin(1000 Shr i, 16)

Next i
```

 Output:

```freebasic
 1000         0000001111101000
 500          0000000111110100
 250          0000000011111010
 125          0000000001111101
 62           0000000000111110
 31           0000000000011111
 15           0000000000001111
 7            0000000000000111
 3            0000000000000011
 1            0000000000000001
 0            0000000000000000
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

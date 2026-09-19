[Home](Home) › [Operators](Category-Operators) › **Operator Shl (Shift Left)**

# Operator Shl (Shift Left)

Shifts the bits of a numeric expression to the left

## Syntax

```freebasic
Declare Operator Shl ( ByRef lhs As Integer, ByRef rhs As Integer ) As Integer
Declare Operator Shl ( ByRef lhs As UInteger, ByRef rhs As UInteger ) As UInteger
Declare Operator Shl ( ByRef lhs As LongInt, ByRef rhs As LongInt ) As LongInt
Declare Operator Shl ( ByRef lhs As ULongInt, ByRef rhs As ULongInt ) As ULongInt
```

## Parameters

- `lhs`
- `rhs`

## Description

**`Operator Shl` (Shift left)** shifts all of the bits in the left-hand side expression (`lhs`) left a number of times specified by the right-hand side expression (`rhs`). Numerically, the result is the same as "`CInt( lhs * 2 ^ rhs )`". For example, "`&b0101 Shl 1`" returns the binary number `&b01010`, and "`5 Shl 1`" returns `10`.

 Neither of the operands are modified in any way.

 If the result is too large to fit inside the result's data type, the leftmost bits are discarded ("shifted out").  
 The results of this operation are undefined for values of `rhs` less than zero, or greater than or equal to the number of bits in the result's data type.

 This operator can be overloaded for user-defined types.

## Return Value

Returns the result of `lhs` being shifted left `rhs` number of times.

## Remarks

### Usage

`result = lhs Shl rhs`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Shl`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Operator Shl= (Shift Left And Assign)`](Operator-Shl-Shift-Left-and-Assign)
- [`Operator Shr (Shift Right)`](Operator-Shr-Shift-Right)
- [`Bin`](Bin)
- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
'Double a number

For i As Integer = 0 To 10

    Print 5 Shl i, Bin(5 Shl i, 16)

Next i
```

 Output:

```freebasic
 5            0000000000000101
 10           0000000000001010
 20           0000000000010100
 40           0000000000101000
 80           0000000001010000
 160          0000000010100000
 320          0000000101000000
 640          0000001010000000
 1280         0000010100000000
 2560         0000101000000000
 5120         0001010000000000
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

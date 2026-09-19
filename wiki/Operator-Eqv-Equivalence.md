[Home](Home) › [Operators](Category-Operators) › **Operator Eqv (Equivalence)**

# Operator Eqv (Equivalence)

Returns the bitwise-and (equivalence) of two numeric values

## Syntax

```freebasic
Declare Operator Eqv ( ByRef lhs As T1, ByRef rhs As T2 ) As Ret
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

This operator returns the bitwise-equivalence of its operands, a logical operation that results in a value with bits set depending on the bits of the operands (for conversion of a boolean to an integer, false or true boolean value becomes 0 or -1 integer value).

 The truth table below demonstrates all combinations of a boolean-equivalence operation:

| Lhs Bit | Rhs Bit | Result |
| --- | --- | --- |
| 0 | 0 | 1 |
| 1 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 1 | 1 |

 No short-circuiting is performed - both expressions are always evaluated.

 The return type depends on the types of values passed. [`Byte`](Byte), [`UByte`](Ubyte) and floating-point type values are first converted to [`Integer`](Integer). If the left and right-hand side types differ only in signedness, then the return type is the same as the left-hand side type (`T1`), otherwise, the larger of the two types is returned. Only if the left and right-hand side types are both [`Boolean`](Boolean), the return type is also [`Boolean`](Boolean).

 This operator can be overloaded for user-defined types.

## Return Value

Returns the bitwise-equivalence of the two operands.

## Remarks

### Usage

`result = lhs Eqv rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [Operator Truth Tables](Bitwise-Operators-Truth-Tables)

## Examples

```freebasic
Dim As UByte a = &b00110011

Dim As UByte b = &b01010101, c

c = a Eqv b '' c = &b10011001
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

[Home](Home) › [Operators](Category-Operators) › **Operator Or (Inclusive Disjunction)**

# Operator Or (Inclusive Disjunction)

Returns the bitwise-or (inclusive disjunction) of two numeric values

## Syntax

```freebasic
Declare Operator Or ( ByRef lhs As T1, ByRef rhs As T2 ) As Ret
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

This operator returns the bitwise-disjunction of its operands, a logical operation that results in a value with bits set depending on the bits of the operands (for conversion of a boolean to an integer, false or true boolean value becomes 0 or -1 integer value).

 The truth table below demonstrates all combinations of a boolean-disjunction operation:

| Lhs Bit | Rhs Bit | Result |
| --- | --- | --- |
| 0 | 0 | 0 |
| 1 | 0 | 1 |
| 0 | 1 | 1 |
| 1 | 1 | 1 |

 No short-circuiting is performed - both expressions are always evaluated.

 The return type depends on the types of values passed. [`Byte`](Byte), [`UByte`](Ubyte) and floating-point type values are first converted to [`Integer`](Integer). If the left and right-hand side types differ only in signedness, then the return type is the same as the left-hand side type (`T1`), otherwise, the larger of the two types is returned. Only if the left and right-hand side types are both [`Boolean`](Boolean), the return type is also [`Boolean`](Boolean).

 This operator can be overloaded for user-defined types.

## Return Value

Returns the bitwise-disjunction of the two operands.

## Remarks

### Usage

`result = lhs Or rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [`OrElse`](Operator-Orelse-Short-Circuit-Inclusive-Disjunction)
- [Operator Truth Tables](Bitwise-Operators-Truth-Tables)

## Examples

```freebasic
' Using the OR operator on two numeric values

Dim As UByte numeric_value1, numeric_value2

numeric_value1 = 15 '00001111

numeric_value2 = 30 '00011110

'Result =  31  =     00011111

Print numeric_value1 Or numeric_value2

Sleep
```

```freebasic
' Using the OR operator on two conditional expressions

Dim As UByte numeric_value

numeric_value = 10

If numeric_value = 5 Or numeric_value = 10 Then Print "Numeric_Value equals 5 or 10"

Sleep

' This will output "Numeric_Value equals 5 or 10" because

' while the first condition of the first IF statement is false, the second is true
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

[Home](Home) › [Operators](Category-Operators) › **Operator Xor (Exclusive Disjunction)**

# Operator Xor (Exclusive Disjunction)

Returns the bitwise-xor (exclusive disjunction) of two numeric values

## Syntax

```freebasic
Declare Operator Xor ( ByRef lhs As T1, ByRef rhs As T2 ) As Ret
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

This operator returns the bitwise-exclusion of its operands, a logical operation that results in a value with bits set depending on the bits of the operands (for conversion of a boolean to an integer, false or true boolean value becomes 0 or -1 integer value).

 The truth table below demonstrates all combinations of a boolean-exclusion operation:

| Lhs Bit | Rhs Bit | Result |
| --- | --- | --- |
| 0 | 0 | 0 |
| 1 | 0 | 1 |
| 0 | 1 | 1 |
| 1 | 1 | 0 |

 No short-circuiting is performed - both expressions are always evaluated.

 The return type depends on the types of values passed. [`Byte`](Byte), [`UByte`](Ubyte) and floating-point type values are first converted to [`Integer`](Integer). If the left and right-hand side types differ only in signedness, then the return type is the same as the left-hand side type (`T1`), otherwise, the larger of the two types is returned. Only if the left and right-hand side types are both [`Boolean`](Boolean), the return type is also [`Boolean`](Boolean).

 This operator can be overloaded for user-defined types.

## Return Value

Returns the bitwise-xor of the two operands.

## Remarks

### Usage

`result = lhs Xor rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [Operator Truth Tables](Bitwise-Operators-Truth-Tables)

## Examples

```freebasic
' Using the XOR operator on two numeric values

Dim As UByte numeric_value1, numeric_value2

numeric_value1 = 15 '00001111

numeric_value2 = 30 '00011110

'Result =  17  =     00010001

Print numeric_value1 Xor numeric_value2

Sleep
```

```freebasic
' Using the XOR operator on two conditional expressions

Dim As UByte numeric_value1, numeric_value2

numeric_value1 = 10

numeric_value2 = 15

If numeric_value1 = 10 Xor numeric_value2 = 20 Then Print "Numeric_Value1 equals 10 or Numeric_Value2 equals 20"

Sleep

' This will output "Numeric_Value1 equals 10 or Numeric_Value2 equals 20"

' because only the first condition of the IF statement is true
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

[Home](Home) › [Operators](Category-Operators) › **Operator Not (Complement)**

# Operator Not (Complement)

Returns the bitwise-not (complement) of a numeric value

## Syntax

```freebasic
Declare Operator Not ( ByRef rhs As Byte ) As Integer
Declare Operator Not ( ByRef rhs As UByte ) As Integer
Declare Operator Not ( ByRef rhs As Single ) As Integer
Declare Operator Not ( ByRef rhs As Double ) As Integer
Declare Operator Not ( ByRef rhs As T ) As T
```

## Parameters

- `rhs`
- `T`

## Description

This operator returns the bitwise-complement of its operand, a logical operation that results in a value with bits set depending on the bits of the operand.  
 (for a boolean type, '`Not` false' returns 'true' and '`Not` true' returns 'false')

 The truth table below demonstrates all combinations of a boolean-complement operation:

| Rhs Bit | Result |
| --- | --- |
| 0 | 1 |
| 1 | 0 |

 This operator can be overloaded for user-defined types.

## Return Value

Returns the bitwise-complement of its operand.

## Remarks

### Usage

`result = Not rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [Operator Truth Tables](Bitwise-Operators-Truth-Tables)

## Examples

```freebasic
' Using the NOT operator on a numeric value

Dim numeric_value As Byte

numeric_value = 15 '00001111

'Result = -16 =     11110000

Print Not numeric_value
```

```freebasic
' Using the NOT operator on conditional expressions

Dim As UByte numeric_value1, numeric_value2

numeric_value1 = 15

numeric_value2 = 25

If Not numeric_value1 = 10 Then Print "Numeric_Value1 is not equal to 10"

If Not numeric_value2 = 25 Then Print "Numeric_Value2 is not equal to 25"

' This will output "Numeric_Value1 is not equal to 10" because

' the first IF statement is false.

' It will not output the result of the second IF statement because the

' condition is true.
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

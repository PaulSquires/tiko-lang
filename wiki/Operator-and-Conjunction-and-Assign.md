[Home](Home) › [Operators](Category-Operators) › **Operator And= (Conjunction And Assign)**

# Operator And= (Conjunction And Assign)

Performs a bitwise-and (conjunction) and assigns the result to a variable

## Syntax

```freebasic
Declare Operator And= ( ByRef lhs As T1, ByRef rhs As T2 )
```

## Parameters

- `lhs`
- `T1`
- `rhs`
- `lhs`
- `T2`

## Description

This operator performs a bitwise-and and assigns the result to a variable (for conversion of a boolean to an integer, false or true boolean value becomes 0 or -1 integer value). It is functionally equivalent to:

`lhs = lhs And rhs`

`And=` compares each bit of its operands, `lhs` and `rhs`, and if both bits are 1, then the corresponding bit in the first operand, `lhs`, is set to 1, otherwise it is set to 0.

 `And=` cannot be used in conditional expressions.

 This operator can be overloaded for user-defined types as a member [`Operator`](Operator) using the appropriate syntax.

 *Note: Similarly to the operator '=\[>\]' (assign), the alternative symbol 'And=>' can be also used.*

## Remarks

### Usage

`lhs And= rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- New to FreeBASIC

### See also

- [`And`](Operator-and-Conjunction)

## Examples

```freebasic
' Using the AND= operator on two numeric values

Dim As UByte numeric_value1, numeric_value2

numeric_value1 = 15 '' 00001111

numeric_value2 = 30 '' 00011110

numeric_value1 And= numeric_value2

'' Result =  14  =     00001110

Print numeric_value1

Sleep
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

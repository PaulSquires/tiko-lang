[Home](Home) › [Operators](Category-Operators) › **Operator Xor= (Exclusive Disjunction And Assign)**

# Operator Xor= (Exclusive Disjunction And Assign)

Performs a bitwise-xor (exclusive disjunction) and assigns the result to a variable

## Syntax

```freebasic
Declare Operator Xor= ( ByRef lhs As T1, ByRef rhs As T2 )
```

## Parameters

- `lhs`
- `T1`
- `rhs`
- `lhs`
- `T2`

## Description

This operator performs a bitwise-or and assigns the result to a variable (for conversion of a boolean to an integer, false or true boolean value becomes 0 or -1 integer value). It is functionally equivalent to:

`lhs = lhs Xor rhs`

`Xor=` compares each bit of its operands, `lhs` and `rhs`, and if both bits are the same (both 1 or both 0), then the corresponding bit in the first operand, `lhs`, is set to 0, otherwise it is set to 1.

 This operator can be overloaded for user-defined types as a member [`Operator`](Operator) using the appropriate syntax.

 *Note: Similarly to the operator '=\[>\]' (assign), the alternative symbol 'Xor=>' can be also used.*

## Remarks

### Usage

`lhs Xor= rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- New to FreeBASIC

### See also

- [`Xor`](Operator-Xor-Exclusive-Disjunction)

## Examples

```freebasic
Dim As UByte a = &b00110011

Dim As UByte b = &b01010101

a Xor= b

'' Result    a = &b01100110

Print Bin(a)
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

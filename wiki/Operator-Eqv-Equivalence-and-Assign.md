[Home](Home) › [Operators](Category-Operators) › **Operator Eqv= (Equivalence And Assign)**

# Operator Eqv= (Equivalence And Assign)

Performs a bitwise-eqv (equivalence) and assigns the result to a variable

## Syntax

```freebasic
Declare Operator Eqv= ( ByRef lhs As T1, ByRef rhs As T2 )
```

## Parameters

- `lhs`
- `T1`
- `rhs`
- `lhs`
- `T2`

## Description

This operator performs a bitwise-eqv and assigns the result to a variable (for conversion of a boolean to an integer, false or true boolean value becomes 0 or -1 integer value). It is functionally equivalent to:

`lhs = lhs Eqv rhs`

`Eqv=` compares each bit of its operands, `lhs` and `rhs`, and if both bits are the same (either both 0 or both 1), then the corresponding bit in the first operand, `lhs`, is set to 1, otherwise it is set to 0.

 This operator can be overloaded for user-defined types as a member [`Operator`](Operator) using the appropriate syntax.

 *Note: Similarly to the operator '=\[>\]' (assign), the alternative symbol 'Eqv=>' can be also used.*

## Remarks

### Usage

`lhs Eqv= rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- New to FreeBASIC

### See also

- [`Eqv`](Operator-Eqv-Equivalence)

## Examples

```freebasic
Dim As UByte a = &b00110011

Dim As UByte b = &b01010101

a Eqv= b

'' Result    a = &b10011001

Print Bin(a)
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

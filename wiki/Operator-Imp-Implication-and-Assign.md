[Home](Home) › [Operators](Category-Operators) › **Operator Imp= (Implication And Assign)**

# Operator Imp= (Implication And Assign)

Performs a bitwise-imp (implication) and assigns the result to a variable

## Syntax

```freebasic
Declare Operator Imp= ( ByRef lhs As T1, ByRef rhs As T2 )
```

## Parameters

- `lhs`
- `T1`
- `rhs`
- `lhs`
- `T2`

## Description

This operator performs a bitwise-imp and assigns the result to a variable (for conversion of a boolean to an integer, false or true boolean value becomes 0 or -1 integer value). It is functionally equivalent to:

`lhs = lhs Imp rhs`

`Imp` is a bitwise operator which is the same as ([`Not`](Operator-Not-Complement) `lhs`) [`Or`](Operator-or-Inclusive-Disjunction) `rhs`. `Imp=` compares each bit of its operands, `lhs` and `rhs`, and if the bit in `lhs` is 0 or the bit in `rhs` is 1, then the corresponding bit in the first operand, `lhs`, is set to 1, otherwise it is set to 0.

 This operator can be overloaded for user-defined types as a member [`Operator`](Operator) using the appropriate syntax.

 *Note: Similarly to the operator '=\[>\]' (assign), the alternative symbol 'Imp=>' can be also used.*

## Remarks

### Usage

`lhs Imp= rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- New to FreeBASIC

### See also

- [`Imp`](Operator-Imp-Implication)
- [Assignment Operators](Assignment-Operators)

## Examples

```freebasic
Dim As UByte a = &b00110011

Dim As UByte b = &b01010101

a Imp= b

'' Result    a = &b11011101

Print Bin(a)
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

[Home](Home) › [Operators](Category-Operators) › **Operator += (Add And Assign)**

# Operator += (Add And Assign)

Adds and assigns a value to a variable

## Syntax

```freebasic
Declare Operator += ( ByRef lhs As T1, ByRef rhs As T2 )
Declare Operator += ( ByRef lhs As T Ptr, ByRef rhs As Integer )
Declare Operator += ( ByRef lhs As String, ByRef rhs As String )
Declare Operator += ( ByRef lhs As WString, ByRef rhs As WString )
```

## Parameters

- `lhs`
- `T1`
- `rhs`
- `lhs`
- `T2`
- `T`

## Description

This operator adds and assigns a value to a variable. It is functionally equivalent to:  
 `lhs = lhs + rhs`  
 For numeric types, the right-hand side expression (`rhs`) will be converted to the left-hand side type (`T1`).

 For string types, this operator is functionally equivalent to [`Operator &= (Concatenate And Assign)`](Operator-Concatenate-and-Assign).

 This operator can be overloaded for user-defined types as a member [`Operator`](Operator) using the appropriate syntax.

 *Note: Similarly to the operator '=\[>\]' (assign), the alternative symbol '+=>' can be also used.*

## Remarks

### Usage

`lhs += rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- New to FreeBASIC

### See also

- [`Operator + (Add)`](Operator-Addition)
- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
Dim n As Double

n = 6

n += 1

Print n

Sleep
```

 Output:

```freebasic
7
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*

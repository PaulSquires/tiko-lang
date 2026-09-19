[Home](Home) › [Operators](Category-Operators) › **Operator &= (Concatenate And Assign)**

# Operator &= (Concatenate And Assign)

Appends and assigns a string onto another string

## Syntax

```freebasic
Declare Operator &= ( ByRef lhs As String, ByRef rhs As T2 )
Declare Operator &= ( ByRef lhs As WString, ByRef rhs As T2 )
```

## Parameters

- `lhs`
- `rhs`
- `lhs`
- `T2`

## Description

This operator appends one string onto another. The right-hand side expression (`rhs`) is converted to a string before concatenation. It is functionally equivalent to,  
 `lhs = lhs & rhs`  
 where the result is assigned back to the left-hand side string.

 This operator can be overloaded for user-defined types as a member [`Operator`](Operator) using the appropriate syntax.

 Note: This operator exists in C/C++ with a different meaning - there it performs a bitwise [`And=`](Operator-and-Conjunction-and-Assign).
 *Note: Similarly to the operator '=\[>\]' (assign), the alternative symbol '&=>' can be also used.*

## Remarks

### Usage

`lhs &= rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- New to FreeBASIC

### See also

- [`Operator & (String Concatenation With Conversion)`](Operator-String-Concatenation-with-Conversion)
- [`Operator += (Add And Assign)`](Operator-Add-and-Assign)

## Examples

```freebasic
Dim s As String = "Hello, "

s &= " world!"

Print s
```

 will produce the output:

```freebasic
Hello, world!
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
